class PhotosController < ApplicationController

  # POST /photos
  def create
    # Write the photo to our uploads photo
    name = params[:photo].original_filename
    directory = "public/upload"
    path = File.join(directory, name)
    File.open(path, "wb") { |f| f.write(params[:photo].read) }
    puts "File uploaded"

    photo = ImageSorcery.new(Rails.root.join('public', 'upload', name))

    puts photo.identify

    render json: {}
  end
end
