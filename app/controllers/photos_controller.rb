class PhotosController < ApplicationController
  include ActionController::Live


  # GET /photos
  # Nabs all photos through SSE that match the provided colour info
  # Param: colour  -> A single hex colour code
  #        colours -> A comma-separated list of 6 hex colour codes
  def index

    col = Colour.all.sample(30)
    response.headers['Content-Type']  = 'text/event-stream'

    begin
      col.each do |c|
        response.stream.write("data: #{c.hex}\n\n")  

        # For now, we're faking computation time with some mathematics
        (30_000_000 * Random.rand).to_i.times do |n|
          n * 1000
        end
      end

    rescue Exception => e
      puts "Rescuing! #{e}"
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
