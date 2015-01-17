class PhotosController < ApplicationController
  include ActionController::Live

  before_action :validate_photo, only: :create
  MAX_RESULTS = 40

  # GET /photos
  # Nabs all photos through Server-Sent Events that match the provided colour info
  # Param:  mode -> either 'photo' or 'colour'
  #         data -> A single hex colour code, without hash, or
  #                 the ID of the previously uploaded photo.
  def index
    response.headers['Content-Type']  = 'text/event-stream'

    begin
      results = 0
      sse = SSE.new(response.stream, retry: 10000)

      # data will either be a Photo from DB, or a colour hash (with HSB, RGB and LAB)
      data = params[:mode] == 'photo' ? Photo.find(params[:mode_data]) : Colour::BuildColourHashFromHex.call(params[:mode_data])

      puts "Data is #{data}"

    
      Photo.includes(:stat).where(from_500px: true).order("created_at DESC").each do |p|
        puts "Starting with photo #{p}"
        match_score = Calculate::MatchScore.call(data, p)

        puts "Match score is #{match_score}"


        if match_score > 0
          puts "We're taking it"
          puts "photo has these colours: #{p.photo_colours}"
          puts "photo has these stats: #{p.stat}"
          results += 1
          sse.write({ 
            photo:    p,
            palette:  p.photo_colours.order("coverage DESC"),
            score:    match_score,
            stats:    p.stat
          }, event: 'photo')

          return true if results >= MAX_RESULTS
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
      sse.write("OVER", event: 'photo')  
      sse.close
    end
  end


  # POST /photos
  # Used when searching by photo.
  # Param: photo -> HttpUpload object
  def create
    if result = Photo.create(image: params[:photo], from_500px: false)
      render json: {
        photo:    result,
        stats:    result.stat,
        colours:  result.photo_colours.order("coverage DESC")
      }
    else
      render json: {error: "Couldn't extract photo information."}, status: 415 
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

  def validate_photo
    # First case: catches blank params, or non-multipart-upload params.
    if !params[:photo].respond_to? :content_type
      render json: {error: "Photo not included with request"}, status: 422
    # second case: catches files that don't have content type of a non-svg image.
    elsif !is_an_image?(params[:photo].content_type)
      render json: {error: "File uploaded not a valid photo"}, status: 415
    end
  end

  def is_an_image?(content_type)
    ( content_type =~ /image/ ) && 
    (
      content_type =~ /png/  || 
      content_type =~ /gif/  ||
      content_type =~ /jp[e]?g/ 
    ) 
  end

end
