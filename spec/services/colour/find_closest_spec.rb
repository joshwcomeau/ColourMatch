require 'rails_helper'
require 'initial_colour_setup'

RSpec.describe Colour::FindClosest do
  include InitialColourSetup

  before(:all) do 
    reset_a_few_colours
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
