class PhotosController < ApplicationController
  include ActionController::Live


  # GET /photos
  # Nabs all photos through SSE that match the provided colour info
  # Param: colour  -> A single hex colour code
  #        colours -> A comma-separated list of 6 hex colour codes
  def index

    response.headers['Content-Type'] = 'text/event-stream'
    sse = SSE.new(response.stream, event: 'message')
    begin
      Colour.first(10).each do |c|
        sse.write(c.hex)
        puts "#{response.stream}"
        sleep 1
      end
    rescue IOError
    ensure
      sse.write("OVER")      
      sse.close
    end


  end

  # POST /create
  # Will be used by rake task to create new photo objects
  def create
    
  end



end
