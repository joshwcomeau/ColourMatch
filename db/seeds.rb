require 'json'

# Constants
JSON_PATH = 'lib/wikipedia_colours_rgb.json'

# Reset all the IDs so we aren't perpetually climbing up
ActiveRecord::Base.connection.tables.each { |t| ActiveRecord::Base.connection.reset_pk_sequence!(t) }


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

reset_colours

def reset_bins
  Bin.destroy_all
  # Current strategy: 6 bins for hue, 2 for saturation (at 25% and 75%), 2 for lightness (at 25% and 75% as well).
  # 24 bins total.

  hues  = [0, 60, 120, 180, 240, 300]
  sats  = [25, 75]
  brits = [25, 75]

  hues.each do |h|
    sats.each do |s|
      brits.each do |b|
        # Let's find our exemplar
        closest_colour = Colour::FindClosest.call({h: h, s: s, b: b})
        Bin.create(exemplar_id: closest_colour.id)
      end
    end
  end 


  # Let's assign all of our colors to the closest bin.
  bins = Bin.includes(:exemplar).all
  Colour.all.each do |c|
    c.bin = Bin::FindClosest.call(c, bins)
    c.save!
  end
end

reset_bins
