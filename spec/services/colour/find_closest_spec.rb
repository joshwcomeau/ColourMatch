require 'rails_helper'

RSpec.describe Colour::FindClosest do
  include ColourSupport

  before(:all) do
    # Create some colors for us to play with
    create_some_colours_and_bins
  end
  describe "finds the closest colour to a given colour" do
    context "when not given a subset" do
      it "finds Bright Lavender" do
        expect(Colour::FindClosest.call({r: 192, g: 147, b: 226}).label).to eq("Bright lavender")
      end
    end
    
    context "when given a colour object" do
      it "finds itself" do
        expect(Colour::FindClosest.call(@c4).label).to eq("Pastel Violet")
      end
    end
  end

end
