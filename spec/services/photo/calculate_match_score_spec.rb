require 'rails_helper'
require 'initial_colour_setup'

RSpec.describe Photo::CalculateMatchScore do
  include InitialColourSetup

  before(:all) do 
    reset_a_few_colours
  end

  # HSB: 190/100/100
  let!(:photo_1) { Photo.create(px_image: 'spec/files/calculate_match_score_1.png', px_id: 1) }
  # HSB: 190/90/100
  let!(:photo_2) { Photo.create(px_image: 'spec/files/calculate_match_score_2.png', px_id: 2) }
  # HSB: 190/80/90
  let!(:photo_3) { Photo.create(px_image: 'spec/files/calculate_match_score_3.png', px_id: 3) }

  it "calculates a score of 0 between two instances of the same photo" do
    expect(Photo::CalculateMatchScore.call(photo_1, photo_1)).to eq(0)
  end

  it "calculates a score of 10 between photos 1 and 2" do
    expect(Photo::CalculateMatchScore.call(photo_1, photo_2)).to eq(10)
  end

  it "calculates a score of 30 between photos 1 and 3" do
    expect(Photo::CalculateMatchScore.call(photo_1, photo_3)).to eq(30)
  end
end

