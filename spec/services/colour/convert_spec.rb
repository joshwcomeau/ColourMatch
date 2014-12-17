require 'rails_helper'

RSpec.describe Colour::Convert do
  describe "converts from one color format to another" do
    describe "Converts RGB to HSL" do
      it "converts when red is max, and green is more than blue" do
        expect(Colour::Convert.call({r: 211, g: 200, b: 50 }, :hsl)).to eq({h: 56,  s: 65,  l: 51}) 
      end

      it "converts when red is max, and green is less than blue" do
        expect(Colour::Convert.call({r: 211, g: 36,  b: 125}, :hsl)).to eq({h: 329, s: 71,  l: 48}) 
      end

      it "converts when green is max" do
        expect(Colour::Convert.call({r: 60,  g: 178, b: 125}, :hsl)).to eq({h: 153, s: 50,  l: 47}) 
      end

      it "converts when blue is max" do
        expect(Colour::Convert.call({r: 11,  g: 0,   b: 157}, :hsl)).to eq({h: 244, s: 100, l: 31}) 
      end

      it "converts when greyscale" do
        expect(Colour::Convert.call({r: 60,  g: 60,  b: 60},  :hsl)).to eq({h: 0,   s: 0,   l: 24}) 
      end
      
    end
    describe "Converts RGB to XYZ" do
      it "converts when RGB are all over 11" do
        expect(Colour::Convert.call({r: 211, g: 200, b: 50 }, :xyz)).to eq({x: 48.09396843392571, y: 55.38772630986121, z: 11.173689673731442})
      end

      it "converts when red is less than 11" do
        expect(Colour::Convert.call({r: 5, g: 36, b: 125}, :xyz)).to eq({x: 4.395134748357606, y: 2.774685980098559, z: 19.70595502679241})
      end

      it "converts when green is less than 11" do
        expect(Colour::Convert.call({r: 60, g: 0, b: 125}, :xyz)).to eq({x: 5.56515026071048, y: 2.44132718197755, z: 19.579943268363976})
      end

      it "converts when blue is less than 11" do
        expect(Colour::Convert.call({r: 245, g: 122, b: 2}, :xyz)).to eq({x: 44.626679340657475, y: 33.335927499952035, z: 4.1398254163975166})
      end

      it "converts when RGB are all under 11" do
        expect(Colour::Convert.call({r: 2, g: 4, b: 6},  :xyz)).to eq({x: 0.10132337764827293, y: 0.11288775572148363, z: 0.1887452194500091})
      end
      
    end

  end
end
