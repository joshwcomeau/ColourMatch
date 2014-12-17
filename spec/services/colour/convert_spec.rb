require 'rails_helper'

RSpec.describe Colour::Convert do
  describe "converts from one color format to another" do
    describe "Converts RGB to HSL" do
      it "converts when red is max, and green is more than blue" do
        expect(Colour::Convert.call({r: 211, g: 200, b: 50 }, :hsl)).to eq({h: 56,  s: 65,  l: 51}) # Red max, green > blue
      end

      it "converts when red is max, and green is less than blue" do
        expect(Colour::Convert.call({r: 211, g: 36,  b: 125}, :hsl)).to eq({h: 329, s: 71,  l: 48}) # Red max, green < blue
      end

      it "converts when green is max" do
        expect(Colour::Convert.call({r: 60,  g: 178, b: 125}, :hsl)).to eq({h: 153, s: 50,  l: 47}) # Green max
      end

      it "converts when blue is max" do
        expect(Colour::Convert.call({r: 11,  g: 0,   b: 157}, :hsl)).to eq({h: 244, s: 100, l: 31}) # Blue max
      end

      it "converts when greyscale" do
        expect(Colour::Convert.call({r: 60,  g: 60,  b: 60},  :hsl)).to eq({h: 0,   s: 0,   l: 24}) # Greyscale
      end
      
    end
  end
end
