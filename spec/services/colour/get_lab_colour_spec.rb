require 'rails_helper'

RSpec.describe Colour::GetLabColour do
  before(:all) do
    # Create some colors for us to play with
    @c1 = Colour.create(label: "Bright lavender", rgb: {r: 191, g: 148, b: 228})
    @c2 = Colour.create(label: "Pale brown", rgb: {r: 152, g: 118, b: 84})
    @c3 = Colour.create(label: "Tangelo", rgb: {r: 249, g: 77, b: 0})
    @c4 = Colour.create(label: "Pastel Violet", rgb: {r: 203, g: 153, b: 201})
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
