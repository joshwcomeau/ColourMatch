class Colour::FindClosest
  def self.call(colour, subset=nil, use_bins=true)
    # We want to find which of the colors in our DB is closest to the provided color.
    # So, we need start by converting to LAB if it isn't already, for accuracy.
    # Then, do some pythagorean math.
    colour = Colour::GetLabColour.call(colour)

    if use_bins
      bin = get_nearest_bin(colour)
      get_nearest_colour(colour, bin.colours)
    else
      subset ||= Colour.all
      get_nearest_colour(colour, subset)
    end
  end



  private

  def self.get_nearest_bin(colour)
    closest_bin = nil
    closest_distance = 1_000_000

    Bin.includes(:exemplar).each do |b|
      distance = Colour::CalculateDistance.call(colour, b.exemplar[:lab])
      if distance < closest_distance
        closest_distance = distance
        closest_bin      = b 
      end      
    end

    closest_bin
  end

  def self.get_nearest_colour(c1, subset)
    closest_color = nil
    closest_distance = 1_000_000

    subset.each do |c2|
      distance = Colour::CalculateDistance.call(c1, c2[:lab])

      if distance < closest_distance
        closest_distance = distance
        closest_color = c2 
      end
    end

    closest_color
  end
end