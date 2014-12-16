require 'json'

# Constants
JSON_PATH = 'lib/wikipedia_colours.json'


# Create colors from Wikipedia JSON
def reset_colours
  Colour.destroy_all
  colour_array = JSON.parse(File.open(JSON_PATH, 'r').read)

  colour_array.each do |colour|

    Colour.create({
      r:     colour["x"],
      g:     colour["y"],
      b:     colour["z"],
      hex:   get_hex_value(colour),
      label: colour["label"]
    })
  end
end

def get_hex_value(colour)
  colour_array = [ colour["x"], colour["y"], colour["z"] ]
  colour_array.inject("") do |result, elem|
    result += elem.to_s(16) # Convert to base 16 (hex)
  end
end

reset_colours