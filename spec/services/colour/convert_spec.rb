require 'rails_helper'

RSpec.describe Colour::Convert do
  context "when not providing valid input" do
    it "raises an error when provided a random string" do
      expect{Colour::Convert.call("yahoo!", :rgb)}.to raise_exception
    end
    
    it "raises an error when provided an array" do
      expect{Colour::Convert.call(["#123456"], :rgb)}.to raise_exception
    end
    
    it "raises an error when not provided a to_type" do
      expect{Colour::Convert.call({r: 2, g: 5, b: 59})}.to raise_exception
    end
  end

  context "when converting from HEX to RGB" do
    it "converts when given a random color with the hashtag" do
      expect(Colour::Convert.call("#123456", :rgb)).to eq({r: 18,  g: 52,  b: 86}) 
    end
    
    it "converts when the hashtag is absent" do
      expect(Colour::Convert.call("123456", :rgb)).to eq({r: 18,  g: 52,  b: 86}) 
    end

    it "converts 3-character hex codes" do
      expect(Colour::Convert.call("369", :rgb)).to eq({r: 51,  g: 102,  b: 153}) 
    end
  end

  context "when converting from RGB to HEX" do
    it "converts when given a random color with the hashtag" do
      expect(Colour::Convert.call({r: 18,  g: 52,  b: 86}, :hex)).to eq("123456") 
    end
    
    it "converts when the hashtag is absent" do
      expect(Colour::Convert.call({r: 18,  g: 52,  b: 86}, :hex)).to eq("123456") 
    end

    it "converts 3-character hex codes" do
      expect(Colour::Convert.call({r: 51,  g: 102,  b: 153}, :hex)).to eq("336699") 
    end
  end  

  context "when converting from RGB to HSB" do
    it "converts when red is max, and green is more than blue" do
      expect(Colour::Convert.call({r: 211, g: 200, b: 50 }, :hsb)).to eq({h: 56,  s: 76,  b: 83}) 
    end

    it "converts when red is max, and green is less than blue" do
      expect(Colour::Convert.call({r: 211, g: 36,  b: 125}, :hsb)).to eq({h: 329, s: 83,  b: 83}) 
    end

    it "converts when green is max" do
      expect(Colour::Convert.call({r: 60,  g: 178, b: 125}, :hsb)).to eq({h: 153, s: 66,  b: 70}) 
    end

    it "converts when blue is max" do
      expect(Colour::Convert.call({r: 11,  g: 0,   b: 157}, :hsb)).to eq({h: 244, s: 100, b: 62}) 
    end

    it "converts when greyscale" do
      expect(Colour::Convert.call({r: 60,  g: 60,  b: 60},  :hsb)).to eq({h: 0,   s: 0,   b: 24}) 
    end

    it "converts black" do
      expect(Colour::Convert.call({r: 0,  g: 0,  b: 0}, :hsb)).to eq({h: 0,   s: 0,   b: 0}) 
    end

    it "converts white" do
      expect(Colour::Convert.call({r: 255,  g: 255,  b: 255}, :hsb)).to eq({h: 0,   s: 0,   b: 100}) 
    end

    it "converts pure red (#F00)" do
      expect(Colour::Convert.call({r: 255,  g: 0,  b: 0}, :hsb)).to eq({h: 0,   s: 100,   b: 100}) 
    end

  end

  context "when converting from HSB to RGB" do
    it "converts when red is max, and green is more than blue" do
      expect(Colour::Convert.call({h: 56,  s: 76,  b: 83}, :rgb)).to eq({r: 211, g: 200, b: 50 }) 
    end

    it "converts when red is max, and green is less than blue" do
      expect(Colour::Convert.call({h: 329, s: 83,  b: 83}, :rgb)).to eq({r: 211, g: 35,  b: 126}) 
    end

    it "converts when green is max" do
      expect(Colour::Convert.call({h: 153, s: 66,  b: 70}, :rgb)).to eq({r: 60,  g: 178, b: 125}) 
    end

    it "converts when blue is max" do
      expect(Colour::Convert.call({h: 244, s: 100, b: 62}, :rgb)).to eq({r: 10,  g: 0,   b: 158}) 
    end

    it "converts when greyscale" do
      expect(Colour::Convert.call({h: 0,   s: 0,   b: 24}, :rgb)).to eq({r: 61,  g: 61,  b: 61}) 
    end

    it "converts black" do
      expect(Colour::Convert.call({h: 0,   s: 0,   b: 0}, :rgb)).to eq({r: 0,  g: 0,  b: 0}) 
    end

    it "converts white" do
      expect(Colour::Convert.call({h: 0,   s: 0,   b: 100}, :rgb)).to eq({r: 255,  g: 255,  b: 255}) 
    end

    it "converts pure red (#F00)" do
      expect(Colour::Convert.call({h: 0,   s: 100,   b: 100}, :rgb)).to eq({r: 255,  g: 0,  b: 0}) 
    end
  end

  context "When converting from RGB to XYZ" do
    it "converts when RGB are all over 11" do
      expect(Colour::Convert.call({r: 211, g: 200, b: 50}, :xyz)).to eq({x: 48.09396843392571, y: 55.38772630986121, z: 11.173689673731442})
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

    it "converts white" do
      expect(Colour::Convert.call({r: 255, g: 255, b: 255},  :xyz)).to eq({x: 95.05, y: 100, z: 108.89999999999999})
    end

    it "converts black" do
      expect(Colour::Convert.call({r: 0, g: 0, b: 0},  :xyz)).to eq({x: 0, y: 0, z: 0})
    end
    
  end

  context "When converting from RGB to LAB" do
    it "converts a primary (red)" do
      expect(Colour::Convert.call({r: 255, g: 0, b: 0}, :lab)).to eq({l: 53.23288178584245, a: 80.10930952982204, b: 67.22006831026425})
    end

    it "converts a secondary (magenta)" do
      expect(Colour::Convert.call({r: 255, g: 0, b: 255}, :lab)).to eq({l: 60.319933664076004, a: 98.25421868616108, b: -60.84298422386232})
    end

    it "converts white" do
      expect(Colour::Convert.call({r: 255, g: 255, b: 255}, :lab)).to eq({l: 100, a: 0.00526049995830391, b: -0.010408184525267927})
    end

    it "converts black" do
      expect(Colour::Convert.call({r: 0, g: 0, b: 0},  :lab)).to eq({l: 0, a: 0, b: 0})
    end

    it "converts a random green" do
      expect(Colour::Convert.call({r: 100, g: 230, b: 25}, :lab)).to eq({l: 81.49626923929404, a: -66.25612887139681, b: 76.08546572431982})
    end

    it "converts a random blue" do
      expect(Colour::Convert.call({r: 33, g: 66, b: 99}, :lab)).to eq({l: 27.075668696502454, a: -0.5029666821680379, b: -23.033897562365745})
    end      

    it "converts a dark color" do
      expect(Colour::Convert.call({r: 10, g: 12, b: 14}, :lab)).to eq({l: 3.244471603373057, a: -0.2243908092490754, b: -1.0871101782008397})
    end

    it "converts a very dark color" do
      expect(Colour::Convert.call({r: 2, g: 3, b: 4}, :lab)).to eq({l: 0.7840334729557448, a: -0.12230357495557342, b: -0.47087271909480033})
    end     

    it "converts a very dark grey" do
      expect(Colour::Convert.call({r: 2, g: 2, b: 2}, :lab)).to eq({l: 0.5483518484793315, a: 0.00007460263512504284, b: -0.00014761148908193356})
    end      

    it "converts a color with L just under 16" do
      expect(Colour::Convert.call({r: 80, g: 12, b: 14}, :lab)).to eq({l: 15.487891901713468, a: 30.92316361949307, b: 17.891489434737224})
    end     

    it "converts a color with L just over 16" do
      expect(Colour::Convert.call({r: 84, g: 12, b: 14}, :lab)).to eq({l: 16.402223020890524, a: 32.30204765409172, b: 19.235045842544267})
    end
  end

  context "when converting from HSB to LAB" do
    it "converts a primary (red)" do
      expect(Colour::Convert.call({h: 0, s: 100, b: 100}, :lab)).to eq({l: 53.23288178584245, a: 80.10930952982204, b: 67.22006831026425})
    end

    it "converts a secondary (magenta)" do
      expect(Colour::Convert.call({h: 300, s: 100, b: 100}, :lab)).to eq({l: 60.319933664076004, a: 98.25421868616108, b: -60.84298422386232})
    end

    it "converts white" do
      expect(Colour::Convert.call({h: 0, s: 0, b: 100}, :lab)).to eq({l: 100, a: 0.00526049995830391, b: -0.010408184525267927})
    end

    it "converts black" do
      expect(Colour::Convert.call({h: 0, s: 0, b: 0},  :lab)).to eq({l: 0, a: 0, b: 0})
    end

    it "converts a random green" do
      expect(Colour::Convert.call({h: 98, s: 89, b: 90}, :lab)).to eq({l: 81.19152714654479, a: -65.91609361859568, b: 75.82842056597488})
    end

    it "converts a random blue" do
      expect(Colour::Convert.call({h: 210, s: 67, b: 39}, :lab)).to eq({l: 27.03003489954316, a: -0.7103420860123666, b: -23.1087587383615})
    end      

    it "converts a dark color" do
      expect(Colour::Convert.call({h: 210, s: 29, b: 5}, :lab)).to eq({l: 2.7252898341538874, a: 0.03272774304315107, b: -0.8925506509624037})
    end

    it "converts a very dark color" do
      expect(Colour::Convert.call({h: 210, s: 50, b: 2}, :lab)).to eq({l: 0.8038289746858496, a: 0.01680058057405842, b: -0.8494034859714505})
    end     

    it "converts a very dark grey" do
      expect(Colour::Convert.call({h: 0, s: 0, b: 1}, :lab)).to eq({l: 0.5483518484793315, a: 0.00007460263512504284, b: -0.00014761148908193356})
    end      

    it "converts a color with L just under 16" do
      expect(Colour::Convert.call({h: 358, s: 85, b: 31}, :lab)).to eq({l: 15.133326928269312, a: 30.928243219036837, b: 17.392536227637166})
    end     

    it "converts a color with L just over 16" do
      expect(Colour::Convert.call({h: 358, s: 86, b: 33}, :lab)).to eq({l: 16.28484648454583, a: 32.632884523338454, b: 19.088932112300792})
    end
  end
end


