class PhotosController < ApplicationController

  # POST /photos
  def create
    
    return render json: {status: 'error', message: "Couldn't save photo to disk."} unless path = save_photo_to_disk(params[:photo])

    filename = params[:photo].original_filename

    # Let's make a histogram at 64 colours.
    histogram = make_histogram(path, 64)

    colour_list = get_colour_list(histogram)

    # Returns an array of arrays, with occurance and RGB:
    # [  [20000, 255,255,255], [19000, 128,52,66], [18000, 0,0,0]  ]

    hsl_colour_list = get_hsl_colours(colour_list)

    hues            = get_channel_stats(hsl_colour_list, :h)
    saturations     = get_channel_stats(hsl_colour_list, :s)
    lightnesses     = get_channel_stats(hsl_colour_list, :l)


    
    puts "SATURATION OUTLIERS:"
    puts saturations[:outliers]

    puts "HUE OUTLIERS:"
    puts hues[:outliers]

    puts "LIGHTNESS OUTLIERS:"
    puts lightnesses[:outliers]

    eight_colour_histogram = make_histogram(path, 8)
    eight_colour_list      = get_colour_list(eight_colour_histogram)

    # For now: Make an image with the top 4 colors + outliers
    final_colours = eight_colour_list
    
    # For saturations, we only want outliers ABOVE the mean.
    saturations[:outliers].each do |s|
      binding.pry
      final_colours.push(s) if s[:color][:hsl][:s] > saturations[:mean]
    end

    # Same for lightness
    lightnesses[:outliers].each do |l|
      final_colours.push(l) if l[:color][:hsl][:l] > lightnesses[:mean]
    end

    # For hue, we'll just take them all
    hues[:outliers].each do |h|
      final_colours.push(h)
    end


    render json: final_colours
  end

  private

  def make_histogram(path, colours)
    `convert #{path}   \
    -format %c         \
    -colors #{colours} \
    histogram:info:- | sort -n -r`
  end

  def get_channel_stats(all_colours, channel)
    colours   = all_colours.map { |c| c[:hsl][channel]}
    mean      = Maths.mean(colours)
    deviation = Maths.standard_deviation(colours)
    outliers  = get_outliers(all_colours, colours, channel, mean, deviation)


    return {
      colours:   colours,
      mean:      mean,
      deviation: deviation,
      outliers:  outliers
    }

  end

  def get_outliers(all_colours, measuring_colours, channel, mean, deviation, threshold=2)
    outliers = []
    all_colours.each do |c| 
      z_score = Maths.z_score(c[:hsl][channel], measuring_colours, mean, deviation)
      if z_score > threshold
        outliers.push({
          color: c,
          z_score: z_score
        })
      end
    end
    outliers
  end


  def get_colour_list(histogram)
    hex_colour_regex = /(?<occurances>[\d]{1,8}):[\s\(\d,\)]+#[\dA-F]{6}\ssrgb\((?<c1>[\d]{1,3}),(?<c2>[\d]{1,3}),(?<c3>[\d]{1,3})\)/

    histogram.scan(hex_colour_regex)
  end

  def get_hsl_colours(colour_list)
    colour_list.map! do |color_array|
      # First, we need to get this in the right format.
      # From  ['255','255','255'] 
      # to    { r: 255, g: 255, b: 255 }
      rgb = {
        r: color_array[1].to_i,
        g: color_array[2].to_i,
        b: color_array[3].to_i
      }

      # Next, we do the conversion
      hsl = Colour::Convert.call(rgb, :hsl)

      {
        occurances: color_array[0].to_i,
        rgb:        rgb,
        hsl:        hsl
      }
    end
  end

  def save_photo_to_disk(photo)
    name = photo.original_filename
    directory = "public/upload"
    path = File.join(directory, name)
    if File.open(path, "wb") { |f| f.write(params[:photo].read) }
      puts "File uploaded"
      return path.to_s
    else
      return false
    end
  end
end
