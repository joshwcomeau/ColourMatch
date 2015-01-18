class Colour::BuildHashFromHex
  def self.call(hex)
    rgb = Colour::Convert.call(hex, :rgb)
    hsb = Colour::Convert.call(rgb, :hsb)
    lab = Colour::Convert.call(rgb, :lab)

    {
      hex: hex,
      rgb: rgb,
      hsb: hsb,
      lab: lab
    }
  end
end