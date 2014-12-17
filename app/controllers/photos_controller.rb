class PhotosController < ApplicationController

  # POST /photos
  def create
    # Write the photo to our uploads photo
    if path = save_photo_to_disk(params[:photo])
      # Let's make a histogram at 64 colours.
      histogram_string = `
        convert #{path}   \
        -format %c        \
        -colors 64        \
        histogram:info:- | sort -n -r`


      colour_list = get_colour_list(histogram_string)
      # Returns an array of arrays, with occurance and RGB:
      # [  [20000, 255,255,255], [19000, 128,52,66], [18000, 0,0,0]  ]

      hsl_colour_list = get_hsl_colours(colour_list)

      puts hsl_colour_list
    end


    


    render json: {}
  end

  private

  def get_colour_list(histogram)
    hex_colour_regex = /(?<occurances>[\d]{1,8}):[\s\(\d,\)]+#[\dA-F]{6}\ssrgb\((?<c1>[\d]{1,3}),(?<c2>[\d]{1,3}),(?<c3>[\d]{1,3})\)/

    histogram.scan(hex_colour_regex)
  end

  def get_hsl_colours(colour_list)
    colour_list.map! do |color_array|
      # First, we need to get this in the right format.
      # From  ['255','255','255'] 
      # to    { r: 255, g: 255, b: 255 }
      formatted_rgb = {
        r: color_array[1].to_i,
        g: color_array[2].to_i,
        b: color_array[3].to_i
      }

      # Next, we do the conversion
      Colour::Convert.call(formatted_rgb, :hsl)
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
