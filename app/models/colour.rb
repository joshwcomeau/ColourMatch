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
#

class Colour < ActiveRecord::Base
  belongs_to :bin

  validates :rgb,   presence: true
  validates :hex,   presence: true
  validates :label, presence: true


  before_validation :set_hex_value
  before_validation :set_lab_value

  def get_hex_value(rgb)
    rgb.inject("") do |result, elem|
      result += elem[1].to_hex # Defined in lib/ext/integer.rb
    end
  end

  private
  
  def set_hex_value
    self.hex = get_hex_value(rgb)
  end

  def set_lab_value
    self.lab = Colour::Convert.call(rgb, :lab)
  end

end
