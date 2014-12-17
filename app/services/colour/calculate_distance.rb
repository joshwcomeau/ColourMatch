class Colour::CalculateDistance
  def self.call(c1, c2)
    c1.symbolize_keys!
    c2.symbolize_keys!

    if Colour::GetType.call(c1) != :lab
      c1 = Colour::Convert.call(c1, :lab)
    end

    if Colour::GetType.call(c2) != :lab
      c2 = Colour::Convert.call(c2, :lab)
    end

    calculate_distance(c1, c2)

  end

  private

  def self.calculate_distance(c1, c2)
    ( (c1[:l] - c2[:l])**2 + (c1[:a] - c2[:a])**2 + (c1[:b] - c2[:b])**2 ) ** 0.5
  end
end