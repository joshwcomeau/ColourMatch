class PhotoColour < ActiveRecord::Base
  belongs_to :photo
  belongs_to :colour
end
