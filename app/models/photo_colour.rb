# == Schema Information
#
# Table name: photo_colours
#
#  id              :integer          not null, primary key
#  photo_id        :integer
#  colour_id       :integer
#  created_at      :datetime
#  updated_at      :datetime
#  outlier         :boolean
#  coverage        :float
#  outlier_channel :string(255)
#  z_score         :float
#

class PhotoColour < ActiveRecord::Base
  belongs_to :photo
  belongs_to :colour
end
