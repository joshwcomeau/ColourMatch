class PhotosController < ApplicationController

  # POST /photos
  # (This is kind of a weird one; The goal is to return a bunch of photos, so it's definitely an 'index' in terms of REST resources.
  # BUT, it involves uploading a photo. The front-end can't issue a GET request with upload data.)
  def index
    
    name = sanitize_name(params[:photo].original_filename)
    return render json: {status: 'error', message: "Couldn't save photo to disk."} unless path = Photo::SaveToDisk.call(params[:photo], name)


    # Let's get 6-bit (64-colour) data
    colour_data_64_bit      = Photo::GetHistogramData.call(path, 64)
    hsb_channel_data_64_bit = Photo::GetHSBChannelStats.call(colour_data_64_bit)

    colour_data_16_bit      = Photo::GetHistogramData.call(path, 16)
    hsb_channel_data_16_bit = Photo::GetHSBChannelStats.call(colour_data_16_bit)

    # Current strategy: Combine the 3-5 most popular 16-bit colors, as well as 0-2 outliers
    results = Photo::ExtractDominantColours.call(colour_data_16_bit, hsb_channel_data_64_bit)


    # Create a png palette for testing
    Photo::CreatePaletteImage.call(results, name) unless Rails.env.production?


    render json: results
  end

  private


  def sanitize_name(name)
    name.gsub(/[^\w\.]/, '')
  end



end
