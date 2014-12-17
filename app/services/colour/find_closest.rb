class Colour::FindClosest
  def self.call(colour)
    # Colour ought to be a hash with the keys as r/g/b, h/s/l or l/a/b. This is how we'll tell them apart.
    from_type = get_type(colour)

    # There are 6 possible conversion paths. For now, I'm going to stick to RGB to HSL and RGB to LAB.
    if from_type == :rgb
      new_color = rgb_to_hsl(colour) if to_type == :hsl
      new_color = rgb_to_lab(colour) if to_type == :lab
    elsif from_type == :hsl
      # do me
    elsif from_type == :lab
      # do me too
    end

    new_color
  end

  private

  def self.get_type(colour)
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

  def self.rgb_to_hsl(colour)
    r_prime = colour[:r] / 255.0
    g_prime = colour[:g] / 255.0
    b_prime = colour[:b] / 255.0

    c_min   = [r_prime, g_prime, b_prime].min
    c_max   = [r_prime, g_prime, b_prime].max

    # Start with L. L is easy
    l = ((c_min + c_max)/2 * 100).round

    # If min and max are the same, we have a greyscale color, which means hue and saturation are both 0
    if c_min == c_max
      return {h: 0, s: 0, l: l}
    end

    # Next up, S
    delta = c_max - c_min
    s = l > 50 ? delta / (2 - c_max - c_min) : delta / (c_max + c_min)
    s = (s * 100).round

    # Finally, H
    case c_max
    when r_prime
      h = (g_prime - b_prime) / delta + (g_prime < b_prime ? 6 : 0)
    when g_prime
      h = (b_prime - r_prime) / delta + 2
    when b_prime
      h = (r_prime - g_prime) / delta + 4
    end

    # Get a rounded value for H in degrees
    h = (h * 60).round

    {
      h: h,
      s: s,
      l: l
    }
  end
end