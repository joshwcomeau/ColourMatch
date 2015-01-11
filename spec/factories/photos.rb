# == Schema Information
#
# Table name: photos
#
#  id                :integer          not null, primary key
#  px_id             :integer
#  px_name           :string(255)
#  px_category       :integer
#  px_user           :json
#  px_for_sale       :boolean
#  px_store_download :boolean
#  px_license_type   :integer
#  px_privacy        :boolean
#  created_at        :datetime
#  updated_at        :datetime
#  px_link           :string(255)
#  image             :string(255)
#  from_500px        :boolean
#  px_image          :string(255)
#

FactoryGirl.define do
  factory :photo do
    
  end

end
