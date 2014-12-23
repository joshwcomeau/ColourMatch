class PhotosController < ApplicationController
  include ActionController::Live


  # GET /photos
  # Nabs all photos through SSE that match the provided colour info
  # Param: colour  -> A single hex colour code
  #        colours -> A comma-separated list of 6 hex colour codes
  def index


    response.headers['Content-Type'] = 'text/event-stream'

    begin
      sleep 10
      response.stream.write("data: #{Colour.first.hex}\n\n")
      puts response
      sleep 10
      response.stream.write("data: #{Colour.second.hex}\n\n")
      puts response
      sleep 10
      response.stream.write("data: #{Colour.third.hex}\n\n")
      puts response
      # Colour.first(10).each do |c|
      #   puts "Now returning #{c.hex}"
      #   sse.write(c.hex)
      #   sleep 1
      # end
    rescue 
      puts "Rescuing!"
      IOError
    ensure
      puts "Connection terminating."
      response.stream.write("data: OVER\n\n")      
      response.stream.close
    end


  end

  # POST /create
  # Will be used by rake task to create new photo objects
  def create
    
  end



end
