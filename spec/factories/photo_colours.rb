# == Schema Information
#
# Table name: photo_colours
#
#  id              :integer          not null, primary key
#  photo_id        :integer
#  colour_id       :integer
#  coverage        :float
#  outlier         :boolean
#  outlier_channel :string(255)
#  z_score         :float
#  created_at      :datetime
#  updated_at      :datetime
#

FactoryGirl.define do
  factory :photo_colour do
    
  end

end
