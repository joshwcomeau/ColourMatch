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
          palette: p.photo_colours.map(&:colour)
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

  # GET /test
  # Photos that I deem problematic get added to /lib/assets/test_images.
  # This action runs those images through the algorithm and outputs them, along with their palettes,
  # so I can quickly assess the efficacy of any tweaks I make. Should probably be removed before release.
  def test
    @images = Dir.glob("public/images/test_images/*.{jpg,jpeg,png,gif}")
    @images.map! do |i|
      path = i.gsub(/public\/images\//, '')
      {
        path: path,
        data: Photo::CreatePaletteFromPhoto.call(i, resize: false, palette_image: false)
      }
    end 
  end

  # GET /kmeans
  # An experimental javascript-based k-means implementation.
  # Should be removed before production.
  def kmeans
    @images = Dir.glob("public/images/test_images/*.{jpg,jpeg,png,gif}")
    @images.map! { |i| i.gsub(/public\/images\//, '') }
  end

end
