class Colour::FindClosest
  def self.call(colour, use_bins=false)
    # We want to find which of the colors in our DB is closest to the provided color.
    # So, we need start by converting to LAB if it isn't already, for accuracy.
    # Then, do some pythagorean math.
    colour = Colour::Convert.call(colour, :lab)

    if use_bins
      bin = is_greyscale?(colour) ? Bin.first : get_nearest_bin(colour)
      get_nearest_colour(colour, bin.colours)
    else
      get_nearest_colour(colour, Colour.all)
    end
  end



  private

  def self.is_greyscale?(colour)
    colour[:a].round == 0 && colour[:b].round == 0
  end

  def self.get_nearest_bin(colour)
    closest_bin = nil
    closest_distance = 1_000_000

    Bin.includes(:exemplar).each do |b|
      distance = Calculate::Distance.call(colour, b.exemplar[:lab])
      if distance < closest_distance
        closest_distance = distance
        closest_bin      = b 
      end      
    end

    closest_bin
  end

  def self.get_nearest_colour(c1, bin_colours)
    closest_color = nil
    closest_distance = 1_000_000

    bin_colours.each do |c2|
      distance = Calculate::Distance.call(c1, c2[:lab].symbolize_keys)

      if distance < closest_distance
        closest_distance = distance
        closest_color    = c2 
      end
    end

    closest_color
  end
end