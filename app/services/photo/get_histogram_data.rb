class Photo::GetHistogramData
  def self.call(path, colours:64, resize: false, dimension: 250)
    path        = strip_version_from_path(path)
    histogram   = make_histogram(path, colours, resize, dimension)
    dimensions  = get_dimensions(path, resize, dimension)
    rgb_data    = parse_histogram(histogram)

    format_data(rgb_data, path, dimensions)
  end

  private

  def self.strip_version_from_path(path)
    path.gsub(/\?v=[\d]+/, '')
  end 

  def self.make_histogram(path, colours, resize, dimension)
    query_string  = "convert #{path} -format %c "
    query_string += "-resize #{dimension}x#{dimension} " if resize
    query_string += "-colors #{colours} histogram:info:- | sort -n -r"

    # run the query, and return what it returns.
    System::RunTerminalCommand.call(query_string)
  end

  # returns an array [w, h]
  def self.get_dimensions(path, resize, dimension)
    query_string  = "convert #{path} -ping -format '%[fx:w]x%[fx:h]' "
    query_string += "-resize #{dimension}x#{dimension} " if resize
    query_string += " info:"

    System::RunTerminalCommand.call(query_string).split('x').map(&:to_i)
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
      hex = Colour::Convert.call(rgb, :hex)
      hsb = Colour::Convert.call(rgb, :hsb)
      lab = Colour::Convert.call(rgb, :lab)

      # IMPORTANT!
      # This is our format for all colour objects that aren't from the DB.
      # No other conversions, after this point, should be necessary.
      {
        occurances: color_array[0].to_i,
        rgb:        rgb,
        hex:        hex,
        hsb:        hsb,
        lab:        lab
      }
    end

    colour_data
  end


end