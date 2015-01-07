class SearchController < ApplicationController

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
end
