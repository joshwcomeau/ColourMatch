class Calculate::Distance
  def self.call(c1, c2, mode: :lab)
    c1 = Colour::Convert.call(c1, mode)
    c2 = Colour::Convert.call(c2, mode)
    mode == :lab ? lab_math(c1, c2) : hsb_math(c1, c2)
  end

  private

  def self.hsb_math(c1, c2)
    ( (c1[:h] - c2[:h])**2 + (c1[:s] - c2[:s])**2 + (c1[:b] - c2[:b])**2 ) ** 0.5
  end

  def self.lab_math(c1, c2)
    ( (c1[:l] - c2[:l])**2*0.7 + (c1[:a] - c2[:a])**2 + (c1[:b] - c2[:b])**2 ) ** 0.5
  end
end