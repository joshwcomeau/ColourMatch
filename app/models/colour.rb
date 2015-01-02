# == Schema Information
#
# Table name: colours
#
#  id         :integer          not null, primary key
#  label      :string(255)
#  created_at :datetime
#  updated_at :datetime
#  hex        :string(255)
#  lab        :json
#  rgb        :json
#  bin_id     :integer
#  hsb        :json
#

class Colour < ActiveRecord::Base
  belongs_to :bin
  has_many :photo_colours
  has_many :photos, through: :photo_colours

  validates :rgb,   presence: true
  validates :hex,   presence: true
  validates :label, presence: true


  before_validation :set_hex_value
  before_validation :set_hsb_value
  before_validation :set_lab_value

  def is_greyscale?
    rgb["r"] == rgb["g"] && rgb["g"] == rgb["b"]
  end

  def self.lookup(c)
    Colour.where("rgb->>'r' = ? AND rgb->>'g' = ? AND rgb->>'b' = ?", c[:r].to_s, c[:g].to_s, c[:b].to_s).take
  end

  private
  
  def set_hex_value
    self.hex = Colour::Convert.call(rgb, :hex)
  end

  def set_lab_value
    self.lab = Colour::Convert.call(rgb, :lab)
  end

  def set_hsb_value
    self.hsb = Colour::Convert.call(rgb, :hsb)
  end  

end
