require 'rails_helper'

RSpec.describe Colour::FindClosest do
  before(:all) do
    # Create some colors for us to play with
    @c1   = Colour.create(label: "Bright lavender", rgb: {r: 191, g: 148, b: 228})
    @c2   = Colour.create(label: "Pale brown", rgb: {r: 152, g: 118, b: 84})
    @c3   = Colour.create(label: "Tangelo", rgb: {r: 249, g: 77, b: 0})
    @c4   = Colour.create(label: "Pastel Violet", rgb: {r: 203, g: 153, b: 201})

    @bin  = Bin.create(exemplar_id: @c1.id)

    Colour.all.each { |c| c.update(bin_id: @bin.id) }
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
