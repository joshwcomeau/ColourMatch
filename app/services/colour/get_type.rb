class Colour::GetType
  def self.call(colour)
    type = nil

    colour.symbolize_keys!

    if    colour.key?(:r) && colour.key?(:g) && colour.key?(:b) 
      type = :rgb
    elsif colour.key?(:h) && colour.key?(:s) && colour.key?(:l)
      type = :hsl
    elsif colour.key?(:l) && colour.key?(:a) && colour.key?(:b)
      type = :lab
    elsif colour.key?(:x) && colour.key?(:y) && colour.key?(:z)
      type = :xyz
    else
      raise "Invalid color type (colour needs to have keys for either :r, :g, :b OR :h, :s, :l OR :l, :a, :b)"
    end

    type
  end
end