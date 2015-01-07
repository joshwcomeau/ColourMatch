require 'rails_helper'

RSpec.describe Calculate::Distance do
  describe "finds the distance between two colors" do
    context "when supplied RGB colours" do
      it "calculates between a light blue and a dark blue" do
        c1 = { r: 20,  g: 40,  b: 60  }
        c2 = { r: 100, g: 200, b: 230 }
        expect(Calculate::Distance.call(c1, c2)).to eq(55.09099484540257)
      end

      it "calculates between red and green" do
        c1 = { r: 255, g: 0,   b: 0   }
        c2 = { r: 0,   g: 255, b: 0   }
        expect(Calculate::Distance.call(c1, c2)).to eq(169.53409280569127)
      end

      it "calculates between white and black" do
        c1 = { r: 255, g: 255, b: 255   }
        c2 = { r: 0,   g: 0,   b: 0     }
        expect(Calculate::Distance.call(c1, c2)).to eq(83.66600346618192)
      end
    end

    context "when supplied an RGB and a LAB colour" do
      it "calculates between a purple and a brown" do
        c1 = { l: 50,  a: 10,  b: -30   }
        c2 = { r: 128, g: 51,  b: 0     }
        expect(Calculate::Distance.call(c1, c2)).to eq(77.57024423817155)
      end

      it "calculates between two very similar reds" do
        c1 = { l: 51,  a: 73,  b: 55    }
        c2 = { r: 238, g: 28,  b: 32    }
        expect(Calculate::Distance.call(c1, c2)).to eq(1.3866065438177115)
      end

    end
  end

end
