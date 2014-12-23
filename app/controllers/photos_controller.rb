class PhotosController < ApplicationController
  include ActionController::Live


  # GET /photos
  # Nabs all photos through SSE that match the provided colour info
  # Param: colour  -> A single hex colour code
  #        colours -> A comma-separated list of 6 hex colour codes
  def index


    response.headers['Content-Type']  = 'text/event-stream'
    response.stream.write("data: 333333\n\n")
    response.stream.write("data: 999999\n\n")
    response.stream.write("data: DDDDDD\n\n")
    response.stream.write("data: OVER\n\n")
    response.stream.close


  end

  # POST /create
  # Will be used by rake task to create new photo objects
  def create
    
  end



end
