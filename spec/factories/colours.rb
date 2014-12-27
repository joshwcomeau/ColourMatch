# == Schema Information
#
# Table name: colours
#
#  id         :integer          not null, primary key
#  label      :string(255)
#  created_at :datetime
#  updated_at :datetime
#  hex        :string(255)
#  lab        :json
#  rgb        :json
#  bin_id     :integer
#  hsb        :json
#

FactoryGirl.define do
  factory :colour do
    rgb   { {r: 118, g: 255, b: 122} }
    label "Screamin' Green"
  end
end
