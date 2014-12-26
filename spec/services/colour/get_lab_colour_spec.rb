require 'rails_helper'

RSpec.describe Colour::GetLabColour do
  include ColourSupport

  before(:all) do
    # Create some colors for us to play with
    create_some_colours_and_bins
  end
  describe "returns LAB colour hash" do
    context "when given a colour object" do
      it "like Bright lavender" do
        expect(Colour::GetLabColour.call(@c1)).to eq({l: 67.91553975149186, a: 31.084093765868737, b: -34.48396064368276})
      end
    end
    
    context "when given an RGB Hash" do
      it "like Pale brown's" do
        expect(Colour::GetLabColour.call({r: 152, g: 118, b: 84})).to eq({l: 52.143760042982336, a: 8.68041166423561, b: 23.80174056602907})
      end
    end

    context "when given an HSB Hash" do
      it "like Tangelo's" do
        expect(Colour::GetLabColour.call({r: 152, g: 118, b: 84})).to eq({l: 52.143760042982336, a: 8.68041166423561, b: 23.80174056602907})
      end
    end
  end

end
