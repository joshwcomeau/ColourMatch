# == Schema Information
#
# Table name: stats
#
#  id         :integer          not null, primary key
#  photo_id   :integer
#  hsb        :json
#  lab        :json
#  created_at :datetime
#  updated_at :datetime
#

class Stat < ActiveRecord::Base
  belongs_to :photo
end
