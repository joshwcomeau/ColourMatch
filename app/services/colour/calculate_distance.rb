class Colour::CalculateDistance
  def self.call(c1, c2)
    c1 = Colour::GetLabColour.call(c1)
    c2 = Colour::GetLabColour.call(c2)

    calculate_distance(c1, c2)

  end

  private

  def self.calculate_distance(c1, c2)
    ( (c1[:l] - c2[:l])**2 + (c1[:a] - c2[:a])**2 + (c1[:b] - c2[:b])**2 ) ** 0.5
  end
end