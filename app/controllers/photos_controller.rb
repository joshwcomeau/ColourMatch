class PhotosController < ApplicationController
  include ActionController::Live

  before_action :validate_photo, only: :create

  MAX_RESULTS      = 40
  PHOTO_THRESHOLD  = 85
  COLOUR_THRESHOLD = 94

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
      data = params[:mode] == 'photo' ? Photo.find(params[:mode_data]) : Colour::BuildHashFromHex.call(params[:mode_data])
    
      Photo.includes(:stat, :photo_colours).where(from_500px: true).find_in_batches do |pgroup|
        pgroup.each do |p|
          match_score = Calculate::MatchScore.call(data, p)

          score_threshold = params[:mode] == 'photo' ? PHOTO_THRESHOLD : COLOUR_THRESHOLD 

          if match_score >= score_threshold
            puts "Photo #{p.id} has an acceptable match score of #{match_score}."
            results += 1
            sse.write({ 
              photo:    p,
              palette:  p.sorted_colours,
              score:    match_score,
              stats:    p.stat
            }, event: 'photo')

            return true if results >= MAX_RESULTS
          end
        end
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
        colours:  result.sorted_colours
      }
    else
      render json: {error: "Couldn't extract photo information."}, status: 415 
    end
  end

  # GET /recent
  # Temporary testing route - just shows all recent additions to the database, from rake task.
  def recent
    @images = Photo.includes(:photo_colours).where(from_500px: true).order("created_at DESC").first(50)
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
