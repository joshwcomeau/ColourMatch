class Colour::GetLabColour
  def self.call(colour)
    if colour.is_a? Colour 
      colour = colour[:lab].symbolize_keys
    elsif colour.is_a? Hash
      colour.symbolize_keys!
      if Colour::GetType.call(colour) != :lab
        colour = Colour::Convert.call(colour, :lab)
      end
    else
      raise "Invalid Colour Input (Must be a Hash or a Colour object)."
    end

    colour
  end
end
