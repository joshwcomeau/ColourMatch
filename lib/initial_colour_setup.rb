require 'json'

module InitialColourSetup
  JSON_PATH = 'lib/wikipedia_colours_rgb.json'

  def reset_colours
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

  def reset_bins
    # Current strategy: 24 hue-based bins (with sat and brit kept at a static 50%) + 1 B&W bin
    
    # Start with B&W
    white = Colour.find_by(label: "White")
    Bin.create(exemplar_id: white.id)


    hues  = (0...360).to_a.select { |h| h % 15 == 0}

    hues.each do |h|
      closest_colour = Colour.where("hsb->>'h' = ? AND hsb->>'s' = ? AND hsb->>'b' = ?", h.to_s, '50', '50').take
      Bin.create(exemplar_id: closest_colour.id)
    end 

    # Let's assign all of our colors to the closest bin.
    bins = Bin.includes(:exemplar).all
    Colour.all.each do |c|
      # Is this greyscale?
      if c[:rgb]["r"] == c[:rgb]["g"] && c[:rgb]["g"] == c[:rgb]["b"]
        c.bin = Bin.first
      else
        c.bin = Bin::FindClosest.call(c, bins)
      end
      c.save!
    end
  end

end