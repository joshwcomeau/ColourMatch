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

require 'rails_helper'
require 'initial_colour_setup'

RSpec.describe Photo, :type => :model do
  include InitialColourSetup

  before(:all) do
    reset_a_few_colours
  end


  context "when creating a photo from a user upload" do
    let(:photo_file)  { File.open("spec/files/cat.jpg") }
    subject           { Photo.create(image: photo_file, from_500px: false).stat }

    it { is_expected.to be_persisted }
    it { is_expected.to be_a Stat }
 
    it "includes HSB analytics" do
      expect(subject.hsb).to eq({"h" => {"mean" => 80.88888888888889, "deviation" => 98.00184238630982}, "s" => {"mean" => 9.072916666666666, "deviation" => 9.497085194573248}, "b" => {"mean" => 62.229166666666664, "deviation" => 21.9139365253048}})
    end

    it "includes LAB analytics" do
      expect(subject.lab).to eq({"l" => {"mean" => 61.94716286549249, "deviation" => 22.491189084320528}, "a" => {"mean" => 0.9894872788225374, "deviation" => 2.702417590368684}, "b" => {"mean" => -0.926962213592392, "deviation" => 4.9738456307623835}})
    end
  end
end
