class ColoursController < ApplicationController

  # GET /colours
  def index
    return render json: {status: 'error', message: "Missing necessary parameter Colour"} unless params[:colour]

    # Convert hex to RGB
    rgb_color = Colour::Convert.call(params[:colour], :rgb)


    nearest_neighbor = Colour::FindClosest.call(rgb_color)

    render json: { original_colour: params[:colour], closest_colour: nearest_neighbor}
  end
end
