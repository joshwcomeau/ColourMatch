require 'json'

module InitialColourSetup
  JSON_PATH = 'lib/wikipedia_colours_rgb.json'

  # Build all 780 colours in our json file. Used by seeds and tests.
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

  # Build a handful of colours, for tests that don't require the full crayon box.
  def reset_a_few_colours
    @c1   = Colour.create(label: "Bright lavender", rgb: {r: 191, g: 148, b: 228})
    @c2   = Colour.create(label: "Pale brown", rgb: {r: 152, g: 118, b: 84})
    @c3   = Colour.create(label: "Tangelo", rgb: {r: 249, g: 77, b: 0})
    @c4   = Colour.create(label: "Pastel Violet", rgb: {r: 203, g: 153, b: 201})
    @bin  = Bin.create(exemplar_id: @c1.id)

    Colour.all.each { |c| c.update(bin_id: @bin.id) }
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