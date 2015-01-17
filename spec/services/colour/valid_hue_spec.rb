require 'rails_helper'

RSpec.describe Colour::ValidHue do
  it "returns true on a saturated colour" do
    c = Colour::BuildColourHashFromHex.call("004b96")
    expect(Colour::ValidHue.call(c)).to eq(true)
  end
  
  it "returns true on a bright, saturated colour" do
    c = Colour::BuildColourHashFromHex.call("2aff00")
    expect(Colour::ValidHue.call(c)).to eq(true)
  end

  it "returns true on a soft but valid colour" do
    c = Colour::BuildColourHashFromHex.call("41573d")
    expect(Colour::ValidHue.call(c)).to eq(true)
  end

  it "returns false on white" do
    c = Colour::BuildColourHashFromHex.call("FFFFFF")
    expect(Colour::ValidHue.call(c)).to eq(false)
  end

  it "returns false on black" do
    c = Colour::BuildColourHashFromHex.call("000000")
    expect(Colour::ValidHue.call(c)).to eq(false)
  end

  it "returns false on grey" do
    c = Colour::BuildColourHashFromHex.call("777")
    expect(Colour::ValidHue.call(c)).to eq(false)
  end

  it "returns false on a navy blue" do
    c = Colour::BuildColourHashFromHex.call("00091a")
    expect(Colour::ValidHue.call(c)).to eq(false)
  end
end


