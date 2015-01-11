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

require 'rails_helper'
require 'initial_colour_setup'

RSpec.describe Photo, :type => :model do
  include InitialColourSetup

  before(:all) do
    reset_colours
  end


  context "when creating a photo from a user upload" do
    let(:photo_file)  { File.open("spec/files/cat.jpg") }
    subject           { Photo.create(image: photo_file, from_500px: false) }

    it { is_expected.to be_persisted }

    it "creates 4 to 6 photo_colour associated objects" do
      expect(subject.photo_colours.count).to be_between(4, 6)
    end

    it "creates a stat object" do
      expect(subject.stat).to be_a Stat
    end
  end
end
