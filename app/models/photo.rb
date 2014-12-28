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
  has_many :photo_colours, dependent: :destroy
  has_many :colours, through: :photo_colours


  validates :px_id, uniqueness: true

  after_create :analyze_photograph


  private

  def analyze_photograph
    colour_data = Photo::CreatePaletteFromPhoto.call(px_image)
    
    # Let's turn our 'occurances' value for each color into percentages, 
    # normalized so they sum to 100.
    resolution = FastImage.size(px_image)
    pixels = resolution[0] * resolution[1]


    colour_data.each do |colo|
      self.photo_colours.create({
        outlier: colo[:type] == 'outlier',
        colour_id: colo[:colour][:id],
        coverage: colo[:occurances] / pixels.to_f * 100
      })
    end

    Photo::CreatePaletteImage.call(colour_data, px_name.underscore) unless Rails.env.production?
  end

end
