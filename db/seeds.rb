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
      label: colour["label"]
    })
  end
end

reset_colours