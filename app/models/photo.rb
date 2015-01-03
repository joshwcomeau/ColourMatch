# == Schema Information
#
# Table name: photos
#
#  id                :integer          not null, primary key
#  px_images         :string(255)      is an Array
#  px_id             :integer
#  px_name           :string(255)
#  px_description    :text
#  px_category       :integer
#  px_user           :json
#  px_rating         :decimal(, )
#  px_status         :integer
#  px_for_sale       :boolean
#  px_store_download :boolean
#  px_license_type   :integer
#  px_privacy        :boolean
#  created_at        :datetime
#  updated_at        :datetime
#  px_link           :string(255)
#

class Photo < ActiveRecord::Base
  # The constant we're using when fetching images from 500px.
  # 1 is 70x70, 2 is 140x140, 3 is 280x280. 4 & 5 are not as predictable.
  IMAGE_SIZE = 3
  MAKE_IMAGE = false


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
    pixels = get_pixel_count.to_f
    
    colour_data.each do |colo|
      self.photo_colours.create({
        outlier: colo[:type] == 'outlier',
        colour_id: colo[:colour][:id],
        coverage: colo[:occurances] / pixels * 100
      })
    end

    Photo::CreatePaletteImage.call(colour_data, px_name.underscore) if MAKE_IMAGE
  end

end
