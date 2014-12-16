class Colour < ActiveRecord::Base
  RGB_VALIDATIONS = { presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0, less_than_or_equal_to: 255 } }

  validates :r, RGB_VALIDATIONS
  validates :g, RGB_VALIDATIONS
  validates :b, RGB_VALIDATIONS
  validates :label, presence: true


  before_save :set_hex_value

  def get_hex_value(r, g, b)
    [r,g,b].inject("") do |result, elem|
      result += elem.to_s(16) # Convert to base 16 (hex)
    end
  end

  private

  def set_hex_value
    self.hex = get_hex_value(r, g, b) if r && g && b
  end

end
