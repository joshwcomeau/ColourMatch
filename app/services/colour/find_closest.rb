class Colour::FindClosest
  def self.call(colour, subset=nil)
    # We want to find which of the colors in our DB is closest to the provided color.
    # So, we need start by converting to LAB if it isn't already, for accuracy.
    # Then, do some pythagorean math.
    colour = Colour::GetLabColour.call(colour)

    subset ||= Colour.all

    get_nearest_colour(colour, subset)

  end

  private

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