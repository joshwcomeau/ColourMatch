require 'rails_helper'
require 'initial_colour_setup'


RSpec.describe Photo::ExtractOutliers do
  include InitialColourSetup

  before(:all) do 
    reset_colours
    reset_bins
  end

  context "when provided 'outliers_for_testing.png'" do
    let(:colour_data) { Photo::GetHistogramData.call('spec/files/outliers_for_testing.png', colours: 64) }
    let(:results)     { Photo::ExtractOutliers.call(colour_data) }

    it "returns an array" do
      expect(results).to be_a Array
    end

    it "returns type as 'outlier'" do
      expect(results.first[:type]).to eq("outlier")
    end 

    it "returns occurances" do
      expect(results.first[:occurances]).to be_a Integer
    end

    it "returns colours" do
      expect(results.first[:colour]).to be_a Colour
    end

    it "returns Bright turquoise as the first outlier" do
      expect(results.first[:colour]).to eq(Colour.find_by(label: 'Bright turquoise'))
    end
    
    it "returns Harvest Gold as the first outlier" do
      expect(results.second[:colour]).to eq(Colour.find_by(label: 'Harvest Gold'))
    end


  end
end


