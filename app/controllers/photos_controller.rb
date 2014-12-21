require 'streamer/sse'

class PhotosController < ApplicationController
  include ActionController::Live


  # GET /photos
  # Nabs all photos through SSE that match the provided colour info
  # Param: colour  -> A single hex colour code
  #        colours -> A comma-separated list of 6 hex colour codes
  def index

    response.headers['Content-Type'] = 'text/event-stream'
    sse = Streamer::SSE.new(response.stream)
    begin
      Colour.first(10).each do |c|
        sse.write(c.hex, event: 'message')
        puts "#{response.stream}"
        sleep 1
      end

      sse.write("OVER", event: 'message')
    rescue IOError
    ensure
      sse.close
    end


  end

  # POST /create
  # Will be used by rake task to create new photo objects
  def create
    
  end



end
