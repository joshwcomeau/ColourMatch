require 'rails_helper'
require 'initial_colour_setup'

RSpec.describe Calculate::MatchScore do
  include InitialColourSetup

  before(:all) do 
    reset_a_few_colours
  end

  context "when using a colour" do
    # Let's use bright red as our sample colour
    let(:colour) { Colour::BuildHashFromHex.call("FF0000") }

    # This image is a perfect match: 100% coverage of the same colour.
    let(:photo_1) { Photo.create(image: File.open('spec/files/calculate_match_score/colour_all_red.png'), from_500px: false) }
    # This image is a decent match: has a close red.
    let(:photo_2) { Photo.create(image: File.open('spec/files/calculate_match_score/colour_close_red.png'), from_500px: false) }
    # This image is all blue. 0% coverage with the red.
    let(:photo_3) { Photo.create(image: File.open('spec/files/calculate_match_score/colour_no_red.png'), from_500px: false) }
    # This image has 8 different reds.
    let(:photo_4) { Photo.create(image: File.open('spec/files/calculate_match_score/several_reds.png'), from_500px: false) }
    # This image has a rainbow of colours.
    let(:photo_5) { Photo.create(image: File.open('spec/files/calculate_match_score/rainbow.png'), from_500px: false) }


    let(:photo_1_score) { Calculate::MatchScore.call(colour, photo_1) }
    let(:photo_2_score) { Calculate::MatchScore.call(colour, photo_2) }
    let(:photo_3_score) { Calculate::MatchScore.call(colour, photo_3) }
    let(:photo_4_score) { Calculate::MatchScore.call(colour, photo_4) }
    let(:photo_5_score) { Calculate::MatchScore.call(colour, photo_5) }

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

    it "gives photo 2 a score around 90" do
      expect(photo_2_score).to be_within(5).of(90)
    end

    it "gives photo 3 a very low score" do
      expect(photo_3_score).to be < 20
    end

    it "gives photo 4 a score of >60" do
      expect(photo_4_score).to be > 60
    end

    it "gives photo 5 a score of <50" do
      expect(photo_5_score).to be < 50
    end
  end


  context "when using a photo" do
    # HSB: 190/100/100
    let(:photo_1) { Photo.create(image: File.open('spec/files/calculate_match_score/photo_blue_1.png'), from_500px: false) }
    # HSB: 190/90/100
    let(:photo_2) { Photo.create(image: File.open('spec/files/calculate_match_score/photo_blue_2.png'), from_500px: false) }
    # HSB: 190/80/90
    let(:photo_3) { Photo.create(image: File.open('spec/files/calculate_match_score/photo_blue_3.png'), from_500px: false) }

    it "calculates a score of 0 between two instances of the same photo" do
      expect(Calculate::MatchScore.call(photo_1, photo_1)).to eq(100)
    end

    it "calculates between 95 and 99 for two very similar blues" do
      expect(Calculate::MatchScore.call(photo_1, photo_2)).to be_within(2).of(97)
    end

    it "calculates between 91 and 95 for two similar blues" do
      expect(Calculate::MatchScore.call(photo_1, photo_3)).to be_within(2).of(93)
    end
  end


end

