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

FactoryGirl.define do
  factory :photo_colour do
    
  end

end
