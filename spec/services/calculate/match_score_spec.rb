require 'rails_helper'
require 'initial_colour_setup'

RSpec.describe Calculate::MatchScore do
  include InitialColourSetup

  before(:all) do 
    reset_a_few_colours
  end

  context "when using a colour" do
    # Let's use bright red as our sample colour
    let(:colour) { Colour::BuildColourHashFromHex.call("FF0000") }

    # This image is a perfect match: 100% coverage of the same colour.
    let(:photo_1) { Photo.create(image: File.open('spec/files/calculate_match_score/colour_all_red.png'), from_500px: false) }
    # This image is a half match: 50% coverage, with the other 50% a very-different blue
    let(:photo_2) { Photo.create(image: File.open('spec/files/calculate_match_score/colour_half_red.png'), from_500px: false) }
    # This image is all blue. 0% coverage with the red.
    let(:photo_3) { Photo.create(image: File.open('spec/files/calculate_match_score/colour_no_red.png'), from_500px: false) }
    # This image has 8 different reds.
    let(:photo_4) { Photo.create(image: File.open('spec/files/calculate_match_score/several_reds.png'), from_500px: false) }
    # This image has a rainbow of colours.
    let(:photo_5) { Photo.create(image: File.open('spec/files/calculate_match_score/rainbow.png'), from_500px: false) }


    let(:photo_1_score) { Calculate::MatchScore.call('colour', colour, photo_1) }
    let(:photo_2_score) { Calculate::MatchScore.call('colour', colour, photo_2) }
    let(:photo_3_score) { Calculate::MatchScore.call('colour', colour, photo_3) }
    let(:photo_4_score) { Calculate::MatchScore.call('colour', colour, photo_4) }
    let(:photo_5_score) { Calculate::MatchScore.call('colour', colour, photo_5) }

    it "gives photo 1 a higher score than photo 2" do
      expect(photo_1_score).to be > photo_2_score
    end

    it "gives photo 2 a higher score than photo 3" do
      expect(photo_2_score).to be > photo_3_score
    end

    it "gives photo 4 a higher score than photo 5" do
      expect(photo_4_score).to be > photo_5_score
    end

    it "gives photo 1 a score of 100" do
      expect(photo_1_score).to eq(100)
    end

    it "gives photo 2 a score around 50" do
      expect(photo_2_score).to be > 48
      expect(photo_2_score).to be < 52
    end

    it "gives photo 3 a score of <50" do
      expect(photo_3_score).to be < 50
    end

    it "gives photo 4 a score of >80" do
      expect(photo_4_score).to be > 80
    end

    it "gives photo 5 a score of <50" do
      expect(photo_5_score).to be < 50
    end

    
  end



  xcontext "when using a photo" do
    # HSB: 190/100/100
    let(:photo_1) { Photo.create(remote_image_url: 'spec/files/calculate_match_score/photo_blue_1.png', from_500px: false) }
    # HSB: 190/90/100
    let(:photo_2) { Photo.create(remote_image_url: 'spec/files/calculate_match_score/photo_blue_2.png', from_500px: false) }
    # HSB: 190/80/90
    let(:photo_3) { Photo.create(remote_image_url: 'spec/files/calculate_match_score/photo_blue_3.png', from_500px: false) }

    it "calculates a score of 0 between two instances of the same photo" do
      expect(Calculate::MatchScore.call('photo', photo_1, photo_1)).to eq(0)
    end

    it "calculates a score of 10 between photos 1 and 2" do
      expect(Calculate::MatchScore.call('photo', photo_1, photo_2)).to eq(10)
    end

    it "calculates a score of 30 between photos 1 and 3" do
      expect(Calculate::MatchScore.call('photo', photo_1, photo_3)).to eq(30)
    end
  end


end

