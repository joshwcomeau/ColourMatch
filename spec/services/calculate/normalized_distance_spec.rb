require 'rails_helper'

RSpec.describe Calculate::NormalizedDistance do

  it "converts 0 to 100" do
    expect(Calculate::NormalizedDistance.call(0)).to eq(100)
  end

  it "converts the max to 0" do
    expect(Calculate::NormalizedDistance.call(150)).to eq(0)
  end

  it "converts 25 to 75" do
    expect(Calculate::NormalizedDistance.call(25)).to eq(75)
  end

end

