# == Schema Information
#
# Table name: photos
#
#  id                   :integer          not null, primary key
#  px_id                :integer
#  px_name              :string(255)
#  px_description       :text
#  px_category          :integer
#  px_user              :json
#  px_rating            :decimal(, )
#  px_status            :integer
#  px_for_sale          :boolean
#  px_store_download    :boolean
#  px_license_type      :integer
#  px_privacy           :boolean
#  created_at           :datetime
#  updated_at           :datetime
#  px_link              :string(255)
#  px_image             :string(255)
#  hue_mean             :float
#  hue_deviation        :float
#  saturation_mean      :float
#  saturation_deviation :float
#  brightness_mean      :float
#  brightness_deviation :float
#

class Photo < ActiveRecord::Base
  # The constant we're using when fetching images from 500px.
  # 1 is 70x70, 2 is 140x140, 3 is 280x280. 4 & 5 are not as predictable.
  IMAGE_SIZE = 3

  has_many :photo_colours, dependent: :destroy
  has_many :colours, through: :photo_colours


  validates :px_id, uniqueness: true

  after_create :analyze_photograph


  private

  def self.resolution_from_500px
    70 * 2**(IMAGE_SIZE-1)
  end

  def get_pixel_count
    ([1,2,3].include? IMAGE_SIZE) ? Photo.resolution_from_500px ** 2 : FastImage.size(px_image).inject(&:*)    
  end

  def analyze_photograph
    colour_data = Photo::CreatePaletteFromPhoto.call(px_image)

    update_channel_stats(colour_data[:stats])
    
    pixels = get_pixel_count.to_f

    colour_data[:colours].each do |colo|
      self.photo_colours.create({
        outlier:    colo[:type] == 'outlier',
        colour_id:  colo[:colour][:id],
        coverage:   colo[:occurances] / pixels * 100
      })
    end
  end

  def update_channel_stats(stats)
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
