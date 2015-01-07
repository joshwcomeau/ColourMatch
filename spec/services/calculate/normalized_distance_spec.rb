require 'rails_helper'

RSpec.describe Calculate::NormalizedDistance do

  it "converts 0 to 100" do
    expect(Calculate::NormalizedDistance.call(0)).to eq(100)
  end

  it "converts the max to 0" do
    expect(Calculate::NormalizedDistance.call(256)).to eq(0)
  end

  it "converts 128 to 50" do
    expect(Calculate::NormalizedDistance.call(128)).to eq(50)
  end

end

