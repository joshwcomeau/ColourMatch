class Colour < ActiveRecord::Base
  before_save :set_hex_value

  def get_hex_value(r, g, b)
    [r,g,b].inject("") do |result, elem|
      result += elem.to_s(16) # Convert to base 16 (hex)
    end
  end

  private

  def set_hex_value
    self.hex = get_hex_value(r, g, b)
  end

end
