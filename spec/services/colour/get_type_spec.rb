require 'rails_helper'

RSpec.describe Colour::GetType do
  it "identifies RGB" do
    expect(Colour::GetType.call(r: 10, g: 20, b: 30)).to eq(:rgb)
  end

  it "identifies HSB" do
    expect(Colour::GetType.call(h: 10, s: 20, b: 30)).to eq(:hsb)
  end

  it "identifies Hex" do
    expect(Colour::GetType.call(hex: "#000000")).to eq(:hex)
  end

  it "identifies LAB" do
    expect(Colour::GetType.call(l: 40, a: -20, b: 20)).to eq(:lab)
  end

  it "identifies XYZ" do
    expect(Colour::GetType.call(x: 40, y: -20, z: 20)).to eq(:xyz)
  end

  it "raises an exception if it's anything else" do
    expect{Colour::GetType.call(r: 40, x: 40, q: 434)}.to raise_exception
  end
end
