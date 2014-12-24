class Bin::FindClosest
  def self.call(colour, bins=nil)
    # Let's grab all our bins (with eager-loaded exemplars) if not supplied
    bins ||= Bin.includes(:exemplar).all

    lab_colour = Colour::GetLabColour.call(colour)

    get_nearest_bin(lab_colour, bins)

  end

  private

  def self.get_nearest_bin(colour, bins)

    closest_color = nil
    closest_distance = 1_000_000

    Colour.all.each do |c2|
      distance = Colour::CalculateDistance.call(c1, c2[:lab])

      if distance < closest_distance
        closest_distance = distance
        closest_color = c2 
      end
    end

    closest_color
  end
end