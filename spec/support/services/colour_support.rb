module ColourSupport
  def create_colours_and_bins
    @c1   = Colour.create(label: "Bright lavender", rgb: {r: 191, g: 148, b: 228})
    @c2   = Colour.create(label: "Pale brown", rgb: {r: 152, g: 118, b: 84})
    @c3   = Colour.create(label: "Tangelo", rgb: {r: 249, g: 77, b: 0})
    @c4   = Colour.create(label: "Pastel Violet", rgb: {r: 203, g: 153, b: 201})

    @bin  = Bin.create(exemplar_id: @c1.id)

    Colour.all.each { |c| c.update(bin_id: @bin.id) }

  end
end