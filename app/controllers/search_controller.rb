class SearchController < ApplicationController

  # POST /search/upload
  # Used when searching by photo.
  # Param: photo -> HttpUpload object
  def upload
    name = sanitize_name(params[:photo].original_filename)
    return render json: {status: 'error', message: "Couldn't save photo to disk."} unless path = Photo::SaveToDisk.call(params[:photo], name)


    # Let's get 6-bit (64-colour) data
    colour_data_64_bit      = Photo::GetHistogramData.call(path, 64)
    hsb_channel_data_64_bit = Photo::GetHSBChannelStats.call(colour_data_64_bit)

    colour_data_16_bit      = Photo::GetHistogramData.call(path, 16)
    hsb_channel_data_16_bit = Photo::GetHSBChannelStats.call(colour_data_16_bit)

    # Current strategy: Combine the 3-5 most popular 16-bit colors, as well as 0-2 outliers
    results = Photo::ExtractDominantColours.call(colour_data_16_bit, hsb_channel_data_64_bit)

    # Find the database colours that match our results
    results.map! { |c| Colour::FindClosest.call(c[:lab]) }


    # Create a png palette for testing
    Photo::CreatePaletteImage.call(results, name) unless Rails.env.production?


    render json: results
  end

  # GET /search
  # Used when searching by colour.
  # Param: colour -> string hex code eg. '#123456'
  def show
    return render json: {status: 'error', message: "Missing necessary parameter Colour"} unless params[:colour]

    # Convert hex to RGB
    rgb_color = Colour::Convert.call(params[:colour], :rgb)


    nearest_neighbor = Colour::FindClosest.call(rgb_color)


    render json: { original_colour: params[:colour], closest_colour: nearest_neighbor}

  end



  private


  def sanitize_name(name)
    name.gsub(/[^\w\.]/, '')
  end

end
