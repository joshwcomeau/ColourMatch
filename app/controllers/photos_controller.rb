class PhotosController < ApplicationController
  include ActionController::Live


  # GET /photos
  # Nabs all photos through Server-Sent Events that match the provided colour info
  # Param:  mode -> either 'photo' or 'colour'
  #         data -> A single hex colour code, without hash, or
  #                 the ID of the previously uploaded photo.
  def index
    response.headers['Content-Type']  = 'text/event-stream'


    begin
      sse = SSE.new(response.stream, retry: 300)

      # data will either be a Photo from DB, or a colour hash (with HSB, RGB and LAB)
      data = params[:mode] == 'photo' ? Photo.find(params[:mode_data]) : Colour::BuildColourHashFromHex.call(params[:mode_data])
    
      # let's do the analyzing in groups of 10, for now
      Photo.where(from_500px: nil).find_in_batches(batch_size: 10) do |photos|

        photos.each do |p|
          match_score = Calculate::MatchScore.call(params[:mode], data, p)
          if match_score > 97
            sse.write({ 
              photo:    p,
              palette:  p.photo_colours,
              score:    match_score
            })
          end
        end

        # # Want them to stream in slowly? Uncomment to fake a database query with math.
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


  # POST /photos
  # Used when searching by photo.
  # Param: photo -> HttpUpload object
  def create
    return render json: {error: "Missing necessary parameter 'photo'"}, status: 422 unless params[:photo]
    
    name = sanitize_name(params[:photo].original_filename)
    return render json: {error: "Couldn't save photo to disk."}, status: 415 unless path = Photo::SaveToDisk.call(params[:photo], name)

    if results = Photo.create(image: path, from_500px: false)
      render json: {
        stats: results,
        colours: results.photo_colours
      }
    else
      render json: {error: "Couldn't extract photo information."}, status: 415 
    end
  ensure
    File.delete(path) if path
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
        data: Photo::CreatePaletteFromPhoto.call(i, resize: true, palette_image: false)
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




  private

  def sanitize_name(name)
    name.gsub(/[^\w\.]/, '')
  end
end
