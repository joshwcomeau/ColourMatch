class PhotosController < ApplicationController
  include ActionController::Live


  # GET /photos
  # Nabs all photos through SSE that match the provided colour info
  # Param: colour  -> A single hex colour code
  #        colours -> A comma-separated list of 6 hex colour codes
  def index


    response.headers['Content-Type']  = 'text/event-stream'

    begin
      response.stream.write("data: #{Colour.third.hex}\n")
      puts "Writing first colour"
      sleep 0.5
      response.stream.write("data: #{Colour.second.hex}\n")
      puts "Writing second colour"
      sleep 0.5
      response.stream.write("data: #{Colour.first.hex}\n")
      puts "Writing third colour"

      puts "response: #{response}"
      puts "response headers: #{response.headers}"

      # Colour.first(10).each do |c|
      #   puts "Now returning #{c.hex}"
      #   sse.write(c.hex)
      #   sleep 1
      # end
    rescue Exception => e
      puts "Rescuing! #{e}"
      IOError
    ensure
      puts "Connection terminating."
      response.stream.write("data: OVER")      
      response.stream.close
    end


  end

  # POST /create
  # Will be used by rake task to create new photo objects
  def create
    
  end



end
