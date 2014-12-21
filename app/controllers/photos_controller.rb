require 'streamer/sse'

class PhotosController < ApplicationController
  include ActionController::Live


  # GET /photos
  # Nabs all photos through SSE that match the provided colour info
  # Param: colour  -> A single hex colour code
  #        colours -> An array of hex colour codes
  def index
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


  end

  # POST /create
  # Will be used by rake task to create new photo objects
  def create
    
  end



end
