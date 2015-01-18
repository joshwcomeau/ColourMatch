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

  # NOTE
  # All of the business logic takes place in service objects.
  # Therefore, the bulk of the tests for photos are in spec/services/photo

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

  context "when creating a photo from 500px" do
    context "when choosing an evenly-colored image" do
      subject           { Photo.create(px_image: "spec/files/lots_of_browns.png", from_500px: true) }

      it { is_expected.to be_persisted }
    end
    
    context "When choosing a rainbow image" do
      subject           { Photo.create(px_image: "spec/files/colours_for_testing.png", from_500px: true) }

      it { is_expected.not_to be_persisted }
    end 

    context "when choosing the cat image with bright eyes" do
      subject           { Photo.create(px_image: "spec/files/cat.jpg", from_500px: true) }

      it { is_expected.to be_persisted }
    end
  end
end
