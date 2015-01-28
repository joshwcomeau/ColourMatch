# == Schema Information
#
# Table name: photos
#
#  id                :integer          not null, primary key
#  px_id             :integer
#  px_name           :string(255)
#  px_category       :integer
#  px_user           :json
#  px_for_sale       :boolean
#  px_store_download :boolean
#  px_license_type   :integer
#  px_privacy        :boolean
#  created_at        :datetime
#  updated_at        :datetime
#  px_link           :string(255)
#  image             :string(255)
#  from_500px        :boolean
#  px_image          :string(255)
#

class Photo < ActiveRecord::Base
  # The constant we're using when fetching images from 500px.
  # 1 is 70x70, 2 is 140x140, 3 is 280x280. 4 & 5 are not as predictable.
  IMAGE_SIZE = 3

  has_many :photo_colours, dependent: :destroy
  has_many :colours, through: :photo_colours

  has_one :stat

  validates :px_id, uniqueness: true, if: :from_500px
  validates :px_image, length: { maximum: 255 }, if: :from_500px
  validates :px_link, length: { maximum: 255 }, if: :from_500px

  before_create :analyze_photograph

  mount_uploader :image, ImageUploader



  scope :from_500px, -> { where(from_500px: true) }

  def outliers
    self.photo_colours.where(outlier: true)
  end

  def sorted_colours
    self.photo_colours.order("outlier ASC").order("coverage DESC")
  end

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
    resize = !from_500px
    colour_data = Photo::CreatePaletteFromPhoto.call(file_path, resize: resize)
    
    # I have enough greyscale photos for now.
    return false if black_and_white(colour_data)


    self.match_category = get_match_category(colour_data) if from_500px

    if !from_500px || match_category

      self.stat = build_stat(colour_data[:stats])


      # Sometimes, an image fails to get processed by ImageMagick's codec.
      # We don't want to store these images.
      if unprocessable_image
        puts "#{px_id} wasn't processable. Skipping this one."
        return false 
      end


      pixels = get_pixel_count.to_f

      colour_data[:colours].each do |colo|
        self.photo_colours.new({
          outlier:            colo[:type] == 'outlier',
          closest_colour_id:  colo[:closest][:id],
          label:              colo[:closest][:label],
          coverage:           colo[:coverage],
          outlier_channel:    colo[:outlier_channel],
          z_score:            colo[:z_score],
          hex:                colo[:colour][:hex],
          rgb:                colo[:colour][:rgb],
          lab:                colo[:colour][:lab],
          hsb:                colo[:colour][:hsb]
        })
      end
    else
      false
    end
  end

  def get_match_category(colour_data)
    if consistent_hue(colour_data)
      "common" 
    elsif has_a_good_outlier(colour_data)
      "outlier"
    end
  end

  def black_and_white(colour_data)
    colour_data[:stats][:hsb][:s][:mean] < 5
  end

  def unprocessable_image
    self.stat.hsb['h']['mean'].nil? || self.stat.lab['l']['mean'].nil? 
  end

  def consistent_hue(colour_data)
    (colour_data[:stats][:hsb][:h][:deviation] < 37) ||
    (colour_data[:stats][:lab][:a][:deviation] + colour_data[:stats][:lab][:b][:deviation] < 8)
  end

  def has_a_good_outlier(colour_data)
    # A good outlier is a really saturated, bright colour in an unsaturated backdrop
    if colour_data[:stats][:hsb][:s][:mean] < 50
      colour_data[:colours].each do |c|
        return true if  ( c[:type] == "outlier" ) && 
                        ( c[:colour][:hsb][:s] > 75 ) && 
                        ( c[:colour][:hsb][:b] > 30 )
      end
    end
    false
  end

  def build_stat(stats)
    washed_stats = remove_nans(stats)
    Stat.new(stats)
  end

  # Recursive helper method to remove any NaN's from our mean/deviation hash, replacing them with 0.
  def remove_nans(stats)
    stats.each_value do |v|
      case v
      when Float 
        v = 0 if v.nan?
      when Hash   then remove_nans(v)
      end
    end
  end  

end
