class Colour::Convert
  def self.call(colour, to_type)
    @colour = colour.is_a?(Hash) ? colour.symbolize_keys : { hex: colour }

    # Colour ought to be a hash with the keys as r/g/b, h/s/l or l/a/b. This is how we'll tell them apart.
    from_type = Colour::GetType.call(@colour)

    # There are 6 possible conversion paths. For now, I'm going to stick to RGB to HSL and RGB to LAB.
    case from_type
    when :hex
      new_color = hex_to_rgb if to_type == :rgb
    when :hsl
      # Do me
    when :lab
      # Do me
    when :rgb
      new_color = rgb_to_hsb if to_type == :hsb
      new_color = rgb_to_lab if to_type == :lab
      new_color = rgb_to_xyz if to_type == :xyz 
    end

    new_color
  end

  private

  def self.hex_to_rgb
    @colour = @colour[:hex]
    
    # strip '#' if provided
    @colour.gsub!(/#/, '')
    
    # turn 3-char hex codes into 6-char ones
    @colour.gsub!(/(\w)/, '\1\1') if @colour.length == 3

    # Separate our 6-char string into 3 separate matches
    rgb = @colour.match(/(..)(..)(..)/)

    {
      r: rgb[1].hex,
      g: rgb[2].hex,
      b: rgb[3].hex,
    }

  end
  
  def self.rgb_to_hsb
    r_prime = @colour[:r] / 255.0
    g_prime = @colour[:g] / 255.0
    b_prime = @colour[:b] / 255.0

    c_min   = [r_prime, g_prime, b_prime].min
    c_max   = [r_prime, g_prime, b_prime].max

    # Start with V. V is easy
    b = (c_max * 100).round

    if c_max == 0 || c_max == c_min
      return {h: 0, s: 0, b: b}
    end

    # Next up, S
    delta = (c_max - c_min)
    s = (delta / c_max * 100).round
    # s = l > 50 ? delta / (2 - c_max - c_min) : delta / (c_max + c_min)
    # s = (s * 100).round

    # Finally, H
    case c_max
    when r_prime
      h = (g_prime - b_prime) / delta + (g_prime < b_prime ? 6 : 0)
    when g_prime
      h = (b_prime - r_prime) / delta + 2
    when b_prime
      h = (r_prime - g_prime) / delta + 4
    end

    # get h in degrees
    h = (h * 60).round

    {
      h: h,
      s: s,
      b: b
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


  #### HELPER METHODS ####

  def self.pivot_for_lab(n)
    n > 0.008856 ? (n ** (1.0 / 3.0)) : (( 903.3 * n + 16) / 116)
  end

  def self.pivot_for_xyz(n)
    n /= 255.0
    n > 0.04045 ? ( ( n + 0.055 ) / 1.055 ) ** 2.4 : n / 12.92
  end
end