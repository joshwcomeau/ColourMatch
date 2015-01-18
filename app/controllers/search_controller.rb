class SearchController < ApplicationController

  # GET /search
  # Used when searching by colour.
  # Param: colour -> string hex code eg. '#123456'
  def show
    return render json: {error: "Missing necessary parameter 'colour'"}, status: 422 unless params[:colour]

    # Get our colourspaces
    colour = Colour::BuildHashFromHex.call(params[:colour])


    nearest_neighbor = Colour::FindClosest.call(colour)


    render json: { original_colour: params[:colour], closest_colour: nearest_neighbor}

  end
end
