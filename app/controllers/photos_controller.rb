class PhotosController < ApplicationController
  include ActionController::Live


  # GET /photos
  # Nabs all photos through SSE that match the provided colour info
  # Param: colour  -> A single hex colour code
  #        colours -> A comma-separated list of 6 hex colour codes
  def index
    col = Colour.all.sample(30)
    response.headers['Content-Type']  = 'text/event-stream'

    print "After getting cols, we have #{col.length}\n\n"
    col.each do |c|
      response.stream.write("data: #{c.hex}\n\n")  
      1_000_000.times do |n|
        n * 1000
      end
    end
    print "After writing 3 colors to stream, we have #{col.length}\n\n"
    
    response.stream.write("data: OVER\n\n")      
    print "After sleeping 1 and writing close to stream, we have #{col.length}\n\n"
    response.stream.close
    print "After closing to stream, we have #{col.length}\n\n"



    # begin

      

    #   puts "response: #{response}"
    #   puts "response headers: #{response.headers}"

    #   # Colour.first(10).each do |c|
    #   #   puts "Now returning #{c.hex}"
    #   #   sse.write(c.hex)
    #   #   sleep 1
    #   # end
    # rescue Exception => e
    #   puts "Rescuing! #{e}"
    #   IOError
    # ensure
    #   puts "Connection terminating."
    #   response.stream.write("data: OVER\n\n")      
    #   response.stream.close
    # end


  end

  # POST /create
  # Will be used by rake task to create new photo objects
  def create
    
  end



end
