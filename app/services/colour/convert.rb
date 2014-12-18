class Colour::Convert
  def self.call(colour, to_type)
    @colour = colour.symbolize_keys

    # Colour ought to be a hash with the keys as r/g/b, h/s/l or l/a/b. This is how we'll tell them apart.
    from_type = Colour::GetType.call(colour)

    # There are 6 possible conversion paths. For now, I'm going to stick to RGB to HSL and RGB to LAB.
    if from_type == :rgb
      new_color = rgb_to_hsl if to_type == :hsl
      new_color = rgb_to_lab if to_type == :lab
      new_color = rgb_to_xyz if to_type == :xyz 
    elsif from_type == :hsl
      new_color = hsl_to_rgb if to_type == :rgb
    elsif from_type == :lab
      # do me too
    end

    new_color
  end

  private

  

  def self.hsl_to_rgb
    h = @colour[:h] / 360.0
    s = @colour[:s] / 100.0
    l = @colour[:l] / 100.0


    if s == 0 # If it's completely unsaturated, lightness is our value (from 0 to 1, still needs 8bit conversion)
      r = g = b = l 
    elsif l <= 0
      r = g = b = 0
    elsif l >= 1
      r = g = b = 1
    else
      temp1, temp2 = mix_lummy_sat(l, s)
      r, g, b = [ h + (1 / 3.0), h, h - (1 / 3.0) ].map { |v|
        hue_to_rgb(rotate_hue(v), temp1, temp2)
      }
    end

    {
      r: (r * 255).round,
      g: (g * 255).round,
      b: (b * 255).round,
    }
  end

  def self.mix_lummy_sat(l, s)
    t = l <= 0.5 ? l * (1.0 + s.to_f) : l + s - (l * s.to_f)
    [ 2.0 * l - t, t]
  end

  def self.hue_to_rgb(h, t1, t2)
    if ((6.0 * h) - 1.0) <= 0
      t1 + ((t2 - t1) * h * 6.0)
    elsif ((2.0 * h) - 1.0) <= 0
      t2
    elsif ((3.0 * h) - 2.0) <= 0
      t1 + (t2 - t1) * ((2 / 3.0) - h) * 6.0
    else
      t1
    end
  end

  def self.rotate_hue(h)
    h += 1.0 if h < 0
    h -= 1.0 if h > 1
    h
  end

  def self.rgb_to_hsl
    r_prime = @colour[:r] / 255.0
    g_prime = @colour[:g] / 255.0
    b_prime = @colour[:b] / 255.0

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

  # this is typically the middle step between RGB and LAB.
  def self.rgb_to_xyz
    new_r = pivot_for_xyz(@colour[:r])
    new_g = pivot_for_xyz(@colour[:g])
    new_b = pivot_for_xyz(@colour[:b])

    {
      x: (new_r * 0.4124 + new_g * 0.3576 + new_b * 0.1805) * 100,
      y: (new_r * 0.2126 + new_g * 0.7152 + new_b * 0.0722) * 100,
      z: (new_r * 0.0193 + new_g * 0.1192 + new_b * 0.9505) * 100
    }
  end

  def self.rgb_to_lab
    xyz = rgb_to_xyz

    new_x = pivot_for_lab(xyz[:x] / 95.047)
    new_y = pivot_for_lab(xyz[:y] / 100.000)
    new_z = pivot_for_lab(xyz[:z] / 108.883)

    l = [ 116 * new_y - 16, 0 ].max
    a = 500 * ( new_x - new_y )
    b = 200 * ( new_y - new_z )

    {
      l: l,
      a: a,
      b: b
    }
  end

  def self.pivot_for_lab(n)
    n > 0.008856 ? (n ** (1.0 / 3.0)) : (( 903.3 * n + 16) / 116)
  end

  def self.pivot_for_xyz(n)
    n /= 255.0
    n > 0.04045 ? ( ( n + 0.055 ) / 1.055 ) ** 2.4 : n / 12.92
  end
end