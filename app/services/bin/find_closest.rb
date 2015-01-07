class Bin::FindClosest
  def self.call(colour, bins=nil)
    # Let's grab all our bins (with eager-loaded exemplars) if not supplied
    bins ||= Bin.includes(:exemplar).all
    lab_colour = Colour::Convert.call(colour, :lab)

    get_nearest_bin(lab_colour, bins)

  end

  private

  def self.get_nearest_bin(colour, bins)
    closest = 1_000_000_000
    nearest_bin = nil

    bins.each do |b|
      dist = Calculate::Distance.call(colour, b.exemplar)
      if dist < closest
        closest = dist
        nearest_bin = b
      end
    end

    nearest_bin
  end
end