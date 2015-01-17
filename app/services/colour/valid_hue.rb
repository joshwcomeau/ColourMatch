# Because not all colours have an accurate hue (for example, according to hue, white is red).
# This service returns a boolean based on whether the hue is 'valid', and should be considered,
# based on the saturation and brightness of the colour.
class Colour::ValidHue
  BRIGHTNESS_THRESHOLD = 18
  SATURATION_THRESHOLD = 18
  def self.call(c)
    c[:hsb][:b] > BRIGHTNESS_THRESHOLD && c[:hsb][:s] > SATURATION_THRESHOLD
  end
end