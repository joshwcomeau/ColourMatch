class PhotosController < ApplicationController

  # POST /photos
  def create
    
    return render json: {status: 'error', message: "Couldn't save photo to disk."} unless path = save_photo_to_disk(params[:photo])

    filename = params[:photo].original_filename

    # Let's make a histogram at 64 colours.
    histogram = make_histogram(path, 64)

    # Let's format it into an array of arrays, with occurance and RGB:
    # [  [20000, 255,255,255], [19000, 128,52,66], [18000, 0,0,0]  ]
    formatted_histogram = parse_histogram(histogram)
    
    

    colour_list = get_hsb_colours(formatted_histogram)


    hues            = get_channel_stats(colour_list, :h)
    saturations     = get_channel_stats(colour_list, :s)
    brightnesses    = get_channel_stats(colour_list, :b)


    
    puts "SATURATION OUTLIERS:"
    puts saturations[:outliers]

    puts "HUE OUTLIERS:"
    puts hues[:outliers]

    puts "LIGHTNESS OUTLIERS:"
    puts brightnesses[:outliers]

    eight_colour_histogram = make_histogram(path, 8)
    eight_colour_list      = parse_histogram(eight_colour_histogram)

    # For now: Make an image with the top 4 colors + outliers
    final_colours = eight_colour_list
    
    # For saturations, we only want outliers ABOVE the mean.
    saturations[:outliers].each do |s|
      binding.pry
      final_colours.push(s) if s[:color][:hsb][:s] > saturations[:mean]
    end

    # Same for brightness
    brightnesses[:outliers].each do |b|
      final_colours.push(b) if b[:color][:hsb][:b] > brightnesses[:mean]
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
    colours   = all_colours.map { |c| c[:hsb][channel]}
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
      z_score = Maths.z_score(c[:hsb][channel], measuring_colours, mean, deviation)
      if z_score > threshold
        outliers.push({
          color: c,
          z_score: z_score
        })
      end
    end
    outliers
  end


  def parse_histogram(histogram)
    hex_colour_regex = /(?<occurances>[\d]{1,8}):[\s\(\d,\)]+#[\dA-F]{6}\ssrgb\((?<c1>[\d]{1,3}),(?<c2>[\d]{1,3}),(?<c3>[\d]{1,3})\)/

    histogram.scan(hex_colour_regex)
  end

  def get_hsb_colours(colour_list)
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
      hsb = Colour::Convert.call(rgb, :hsb)

      {
        occurances: color_array[0].to_i,
        rgb:        rgb,
        hsb:        hsb
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
