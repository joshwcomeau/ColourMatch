require 'streamer/sse'

class ColoursController < ApplicationController
  include ActionController::Live

  # GET /colours
  def index
    return render json: {status: 'error', message: "Missing necessary parameter Colour"} unless params[:colour]

    # Convert hex to RGB
    rgb_color = Colour::Convert.call(params[:colour], :rgb)


    nearest_neighbor = Colour::FindClosest.call(rgb_color)

    response.headers['Content-Type'] = 'text/event-stream'
    sse = Streamer::SSE.new(response.stream)
    begin
      10.times do
        puts "writing"
        sse.write({ :results => "woohoo, returning #{results}", event: 'message' })
        sleep 1
      end
    rescue IOError
    ensure
      sse.close
    end



    render json: { original_colour: params[:colour], closest_colour: nearest_neighbor}
  end
end
