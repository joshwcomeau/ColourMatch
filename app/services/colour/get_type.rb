class Colour::GetType
  def self.call(colour)
    type = nil

    if colour.key?(:r) && colour.key?(:g) && colour.key?(:b) 
      type = :rgb
    elsif colour.key(:h) && colour.key(:s) && colour.key?(:l)
      type = :hsl
    elsif colour.key(:l) && colour.key(:a) && colour.key?(:b)
      type = :lab
    else
      raise "Invalid color type (colour needs to have keys for either :r, :g, :b OR :h, :s, :l OR :l, :a, :b)"
    end

    type
  end
end