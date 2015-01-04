# == Schema Information
#
# Table name: photo_colours
#
#  id                :integer          not null, primary key
#  photo_id          :integer
#  closest_colour_id :integer
#  created_at        :datetime
#  updated_at        :datetime
#  outlier           :boolean
#  coverage          :float
#  outlier_channel   :string(255)
#  z_score           :float
#  hex               :string(255)
#  lab               :json
#  rgb               :json
#  hsb               :json
#  label             :string(255)
#

FactoryGirl.define do
  factory :photo_colour do
    
  end

end
