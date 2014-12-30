class PhotosController < ApplicationController
  include ActionController::Live


  # GET /photos
  # Nabs all photos through SSE that match the provided colour info
  # Param: colour  -> A single hex colour code
  #        colours -> A comma-separated list of 6 hex colour codes
  def index

    photos = Photo.includes(:colours).last(20)
    response.headers['Content-Type']  = 'text/event-stream'

    begin
      sse = SSE.new(response.stream, retry: 300)
    
      photos.each do |p|

        sse.write({ 
          photo: p,
          palette: p.colours
        })

        # Want them to stream in slowly? Uncomment to fake a database query with math.
        # (30_000_000 * Random.rand).to_i.times do |n|
        #   n * 1000
        # end
      end

    rescue Exception => e
      puts "Rescuing! #{e}"
      IOError
    ensure
      puts "Connection terminating."
      sse.write("OVER")  
      sse.close
    end


  end

  # POST /create
  # Will be used by rake task to create new photo objects
  def create
    
  end



end
