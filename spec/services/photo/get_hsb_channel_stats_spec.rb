require 'rails_helper'

RSpec.describe Photo::GetHSBChannelStats do

  let(:colour_data) { Photo::GetHistogramData.call('spec/files/hsb_channel_test_image.png') }
  let(:stats)       { Photo::GetHSBChannelStats.call(colour_data[:colours]) }

  it "returns an array" do
    expect(stats).to be_a Array
  end

  it "returns 3 stats" do
    expect(stats.count).to eq(3)
  end

  describe "hue" do
    # values [0, 0, 201]
    subject { stats.first }

    it { is_expected.to be_a Hash }

    it "returns the right channel" do
      expect(subject[:channel]).to eq(:h)
    end

    it "returns the right stats" do
      expect(subject[:mean]).to eq(67)
      expect(subject[:deviation]).to eq(95.5519203968472)
    end
  end

  describe "saturation" do
    # values [0, 0, 50]
    subject { stats.second }

    it { is_expected.to be_a Hash }

    it "returns the right channel" do
      expect(subject[:channel]).to eq(:s)
    end

    it "returns the right stats" do
      expect(subject[:mean]).to eq(16.666666666666668)
      expect(subject[:deviation]).to eq(23.769134427076413)
    end
  end

  describe "brightness" do
    # values [0, 100, 50]
    subject { stats.third }

    it { is_expected.to be_a Hash }

    it "returns the right channel" do
      expect(subject[:channel]).to eq(:b)
    end

    it "returns the right stats" do
      expect(subject[:mean]).to eq(50)
      expect(subject[:deviation]).to eq(41.16934847963091)
    end
  end


end


