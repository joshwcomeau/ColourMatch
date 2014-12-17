require 'rails_helper'

RSpec.describe Colour::FindClosest do
  before(:all) do
    # Create some colors for us to play with
    Colour.create(label: "Bright lavender", rgb: {r: 191, g: 148, b: 228})
    Colour.create(label: "Pale brown", rgb: {r: 152, g: 118, b: 84})
    Colour.create(label: "Tangelo", rgb: {r: 249, g: 77, b: 0})
    Colour.create(label: "Pastel Violet", rgb: {r: 203, g: 153, b: 201})
  end
  describe "finds the closest colour to a given colour" do
    it "finds Bright Lavender" do

      expect(Colour::FindClosest.call({r: 192, g: 147, b: 226}).label).to eq("Bright lavender")
    end
  end

end
