class Colour::Convert
  def self.call(colour, to_type)
    # Colour ought to be a hash with the keys as r/g/b, h/s/l or l/a/b. This is how we'll tell them apart.
    from_type = get_type(colour)

    # There are 6 possible conversion paths. For now, I'm going to stick to RGB to HSL and RGB to LAB.
    if from_type == :rgb
      new_color = rgb_to_hsl(colour) if to_type == :hsl
      new_color = rgb_to_lab(colour) if to_type == :lab
      new_color = rgb_to_xyz(colour) if to_type == :xyz 
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
    elsif colour.key(:x) && colour.key(:y) && colour.key?(:z)
      type = :xyz
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
# function RGBtoXYZ(R, G, B)
# {
#     var_R = parseFloat( R / 255 )        //R from 0 to 255
#     var_G = parseFloat( G / 255 )        //G from 0 to 255
#     var_B = parseFloat( B / 255 )        //B from 0 to 255

#     if ( var_R > 0.04045 ) var_R = ( ( var_R + 0.055 ) / 1.055 ) ^ 2.4
#     else                   var_R = var_R / 12.92
#     if ( var_G > 0.04045 ) var_G = ( ( var_G + 0.055 ) / 1.055 ) ^ 2.4
#     else                   var_G = var_G / 12.92
#     if ( var_B > 0.04045 ) var_B = ( ( var_B + 0.055 ) / 1.055 ) ^ 2.4
#     else                   var_B = var_B / 12.92

#     var_R = var_R * 100
#     var_G = var_G * 100
#     var_B = var_B * 100

#     //Observer. = 2°, Illuminant = D65
#     X = var_R * 0.4124 + var_G * 0.3576 + var_B * 0.1805
#     Y = var_R * 0.2126 + var_G * 0.7152 + var_B * 0.0722
#     Z = var_R * 0.0193 + var_G * 0.1192 + var_B * 0.9505
#     return [X, Y, Z]
# }

  # this is typically the middle step between RGB and LAB.
  def self.rgb_to_xyz(colour)
    r_prime = colour[:r] / 255.0
    g_prime = colour[:g] / 255.0
    b_prime = colour[:b] / 255.0

    new_r = r_prime > 0.04045 ? ( ( r_prime + 0.055 ) / 1.055 ) ** 2.4 : r_prime / 12.92
    new_g = g_prime > 0.04045 ? ( ( g_prime + 0.055 ) / 1.055 ) ** 2.4 : g_prime / 12.92
    new_b = b_prime > 0.04045 ? ( ( b_prime + 0.055 ) / 1.055 ) ** 2.4 : b_prime / 12.92

    {
      x: (new_r * 0.4124 + new_g * 0.3576 + new_b * 0.1805) * 100,
      y: (new_r * 0.2126 + new_g * 0.7152 + new_b * 0.0722) * 100,
      z: (new_r * 0.0193 + new_g * 0.1192 + new_b * 0.9505) * 100
    }
  end

  def self.rgb_to_lab(colour)


  end
end

# // user colour
# var Red   = 56;
# var Green = 79;
# var Blue  = 132;

# // user colour converted to XYZ space
# XYZ = RGBtoXYZ(Red,Green,Blue)
# var colX = XYZ[0];
# var colY = XYZ[1];
# var colZ = XYZ[2];

# // alert(XYZ)

# LAB = XYZtoLAB(colX, colY, colZ)

# alert(LAB)



# function XYZtoLAB(x, y, z)
# {
#     var ref_X =  95.047;
#     var ref_Y = 100.000;
#     var ref_Z = 108.883;

#     var_X = x / ref_X          //ref_X =  95.047   Observer= 2°, Illuminant= D65
#     var_Y = y / ref_Y          //ref_Y = 100.000
#     var_Z = z / ref_Z          //ref_Z = 108.883

#     if ( var_X > 0.008856 ) var_X = var_X ^ ( 1/3 )
#     else                    var_X = ( 7.787 * var_X ) + ( 16 / 116 )
#     if ( var_Y > 0.008856 ) var_Y = var_Y ^ ( 1/3 )
#     else                    var_Y = ( 7.787 * var_Y ) + ( 16 / 116 )
#     if ( var_Z > 0.008856 ) var_Z = var_Z ^ ( 1/3 )
#     else                    var_Z = ( 7.787 * var_Z ) + ( 16 / 116 )

#     CIE_L = ( 116 * var_Y ) - 16
#     CIE_a = 500 * ( var_X - var_Y )
#     CIE_b = 200 * ( var_Y - var_Z )

# return [CIE_L, CIE_a, CIE_b]
# }