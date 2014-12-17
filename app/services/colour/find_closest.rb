class Colour::FindClosest
  def self.call(colour)
    # We want to find which of the colors in our DB is closest to the provided color.
    # So, we need start by converting to LAB if it isn't already, for accuracy.
    # Then, do some pythagorean math.

    if Colour::GetType.call(colour) != :lab
      colour = Colour::Convert(colour, :lab)
    end

    
  end

  private
end