require 'rails_helper'

RSpec.describe Photo::ExtractMostCommonColours do
  include ColourSupport
  before(:all) { create_colours_and_bins }

  context "when provided 'colours_for_testing.png'" do
    let(:colour_data) { Photo::GetHistogramData.call('spec/files/colours_for_testing.png', 16) }
    let(:results)     { Photo::ExtractMostCommonColours.call(colour_data) }

    it "returns an array" do
      expect(results).to be_a Array
    end

    it "returns Colour objects" do
      expect(results.first).to be_a Colour
    end
  end
end


