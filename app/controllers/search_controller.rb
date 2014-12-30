class SearchController < ApplicationController

  # POST /search/upload
  # Used when searching by photo.
  # Param: photo -> HttpUpload object
  def upload
    return render json: {error: "Missing necessary parameter 'photo'"}, status: 422 unless params[:photo]
    
    name = sanitize_name(params[:photo].original_filename)
    return render json: {error: "Couldn't save photo to disk."}, status: 415 unless path = Photo::SaveToDisk.call(params[:photo], name)


    results = Photo::CreatePaletteFromPhoto.call(path, resize: true, palette_image: true)

    render json: results

  end

  # GET /search
  # Used when searching by colour.
  # Param: colour -> string hex code eg. '#123456'
  def show
    return render json: {error: "Missing necessary parameter 'colour'"}, status: 422 unless params[:colour]

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
