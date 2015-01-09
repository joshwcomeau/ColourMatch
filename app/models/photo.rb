# == Schema Information
#
# Table name: photos
#
#  id                   :integer          not null, primary key
#  image                :string(255)
#  from_500px           :boolean
#  hue_mean             :float
#  hue_deviation        :float
#  saturation_mean      :float
#  saturation_deviation :float
#  brightness_mean      :float
#  brightness_deviation :float
#  px_id                :integer
#  px_image             :string(255)
#  px_link              :string(255)
#  px_name              :string(255)
#  px_category          :integer
#  px_user              :json
#  px_for_sale          :boolean
#  px_store_download    :boolean
#  px_license_type      :integer
#  px_privacy           :boolean
#  created_at           :datetime
#  updated_at           :datetime
#

class Photo < ActiveRecord::Base
  # The constant we're using when fetching images from 500px.
  # 1 is 70x70, 2 is 140x140, 3 is 280x280. 4 & 5 are not as predictable.
  IMAGE_SIZE = 3

  has_many :photo_colours, dependent: :destroy
  has_many :colours, through: :photo_colours

  validates :px_id, uniqueness: true, if: :from_500px

  after_create :analyze_photograph

  mount_uploader :image, ImageUploader



  scope :from_500px, -> { where(from_500px: true) }

  private

  def file_path
    # Because we're storing uploaded images and not storing 500px,
    # the path is different. One is CarrierWave, the other is just a string.
    from_500px ? px_image : image.file.file
  end

  def self.resolution_from_500px
    70 * 2**(IMAGE_SIZE-1)
  end

  def get_pixel_count
    if from_500px && [1,2,3].include?(IMAGE_SIZE)
      Photo.resolution_from_500px ** 2
    else
      `identify -format "%wx%h" #{image.file.path}`.split(/x/).map(&:to_i).inject(&:*)  
    end  
  end

  def analyze_photograph

    colour_data = Photo::CreatePaletteFromPhoto.call(file_path)

    update_channel_stats(colour_data[:stats])
    
    pixels = get_pixel_count.to_f



    colour_data[:colours].each do |colo|
      self.photo_colours.create({
        outlier:            colo[:type] == 'outlier',
        closest_colour_id:  colo[:closest][:id],
        label:              colo[:closest][:label],
        coverage:           colo[:occurances] / pixels * 100,
        outlier_channel:    colo[:outlier_channel],
        z_score:            colo[:z_score],
        hex:                colo[:colour][:hex],
        rgb:                colo[:colour][:rgb],
        lab:                colo[:colour][:lab],
        hsb:                colo[:colour][:hsb],
      })
    end
  end

  def update_channel_stats(stats)
    # replace NaN's with 0's.
    stats.map! do |s|
      s[:mean]      = 0 if s[:mean].nan?
      s[:deviation] = 0 if s[:deviation].nan?
      s
    end

    self.update({
      hue_mean:             stats.first[:mean],
      hue_deviation:        stats.first[:deviation],
      saturation_mean:      stats.second[:mean],
      saturation_deviation: stats.second[:deviation],
      brightness_mean:      stats.third[:mean],
      brightness_deviation: stats.third[:deviation],
    })
  end

end
