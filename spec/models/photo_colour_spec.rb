# == Schema Information
#
# Table name: photo_colours
#
#  id         :integer          not null, primary key
#  photo_id   :integer
#  colour_id  :integer
#  occurances :integer
#  type       :string(255)
#  created_at :datetime
#  updated_at :datetime
#

require 'rails_helper'

RSpec.describe PhotoColour, :type => :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
