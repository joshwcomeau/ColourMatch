require 'rails_helper'
require 'initial_colour_setup'


RSpec.describe Photo::ExtractMostCommonColours do
  include InitialColourSetup

  before(:all) do 
    reset_colours
    reset_bins
  end

  context "when provided 'extract_most_common_colours_test_image.png'" do
    let(:colour_data) do 
      Photo::GetHistogramData.call(
        'spec/files/extract_most_common_colours_test_image.png', 
        colours: Photo::CreatePaletteFromPhoto::LORES
      ) 
    end
    let(:results)     { Photo::ExtractMostCommonColours.call(colour_data) }

    it "returns an array" do
      expect(results).to be_a Array
    end

    it "returns 6 things" do
      expect(results.count).to eq(4)
    end

    it "returns Colour objects" do
      expect(results.first[:closest]).to be_a Colour
    end

    it "returns the type of the colour (common or outlier)" do
      expect(results.first[:type]).to eq("common")
    end

    it "returns the number of occurances as an int" do
      expect(results.first[:occurances]).to be_a Integer
    end


    it "returns the most common colour first" do
      expect(results.first[:colour]).to include(rgb: {r: 255, g: 156, b: 0})
    end
    it "finds the closest colour to it (Orange RYB)" do
      expect(results.first[:closest]).to eq(Colour.find_by(label: 'Orange (RYB)'))
    end


    it "returns the second most common colour second" do
      expect(results.second[:colour]).to include(rgb: {r: 0, g: 255, b: 120})
    end
    it "finds the closest colour to it (Guppie Green)" do
      expect(results.second[:closest]).to eq(Colour.find_by(label: 'Guppie green'))
    end


    it "returns the least common colour last " do
      expect(results.last[:colour]).to include(rgb: {r: 96, g: 0, b: 255})
    end
    it "finds the closest colour to it ('Electric indigo')" do
      expect(results.last[:closest]).to eq(Colour.find_by(label: 'Electric indigo'))
    end

  end
end


