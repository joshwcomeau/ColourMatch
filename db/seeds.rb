require 'json'

# Constants
JSON_PATH = 'lib/wikipedia_colours_rgb.json'


# Create colors from Wikipedia JSON
def reset_colours
  Colour.destroy_all
  colour_array = JSON.parse(File.open(JSON_PATH, 'r').read)

  colour_array.each do |colour|

    Colour.create({
      rgb: { 
        r: colour["r"],
        g: colour["g"],
        b: colour["b"]
      },
      label: colour["label"]
    })
  end
end

def create_bins
  # Current strategy: 6 bins for hue, 2 for saturation (at 25% and 75%), 2 for lightness (at 25% and 75% as well).
  # 24 bins total.

  hues  = [0, 60, 120, 180, 240, 300]
  sats  = [25, 75]
  brits = [25, 75]

  hues.each do |h|
    sats.each do |s|
      brits.each do |b|
        lab_color = Colour::Convert({h: h, s: s, b: b}, :lab)
      end
    end
  end 
end

reset_colours