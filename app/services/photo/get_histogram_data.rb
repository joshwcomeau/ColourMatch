class Photo::GetHistogramData
  def self.call(path, colours:64, resize: false, resize_dimension: 250)
    path        = strip_version_from_path(path)
    resize      = resize_str(resize, resize_dimension)
    histogram   = make_histogram(path, resize, colours)
    dimensions  = get_dimensions(path, resize)
    rgb_data    = parse_histogram(histogram)

    format_data(rgb_data, path, dimensions)
  end

  private

  def self.strip_version_from_path(path)
    path.gsub(/\?v=[\d]+/, '')
  end 

  def self.resize_str(resize, dimension)
    resize ? "-resize #{dimension}x#{dimension}" : ""
  end

  def self.make_histogram(path, resize, colours)
    `convert #{path}    \
    -format %c          \
    #{resize}           \
    -colors #{colours}  \
    histogram:info:-    | sort -n -r`
  end

  # returns an array [w, h]
  def self.get_dimensions(path, resize)
    `convert #{path} #{resize} -ping -format '%[fx:w]x%[fx:h]' info:`.split('x').map(&:to_i)
  end

  def self.parse_histogram(histogram)
    hex_colour_regex = /(?<occurances>[\d]{1,8}):\s\(\s*(?<c1>[\d]{1,3}),\s*(?<c2>[\d]{1,3}),\s*(?<c3>[\d]{1,3})/
    histogram.scan(hex_colour_regex)
  end

  def self.format_data(rgb_data, path, dimensions)
    colour_data = {
      width:  dimensions[0],
      height: dimensions[1],
      pixels: dimensions[0] * dimensions[1]
    }

    colour_data[:colours] = rgb_data.map! do |color_array|
      # First, we need to get this in the right format.
      # From  ['255','255','255'] 
      # to    { r: 255, g: 255, b: 255 }
      rgb = {
        r: color_array[1].to_i,
        g: color_array[2].to_i,
        b: color_array[3].to_i
      }

      # Next, we do the conversions
      hsb = Colour::Convert.call(rgb, :hsb)
      lab = Colour::Convert.call(rgb, :lab)

      # IMPORTANT!
      # This is our format for all colour objects that aren't from the DB.
      # No other conversions, after this point, should be necessary.
      {
        occurances: color_array[0].to_i,
        rgb:        rgb,
        hsb:        hsb,
        lab:        lab
      }
    end

    colour_data
  end


end