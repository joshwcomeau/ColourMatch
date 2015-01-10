require 'rails_helper'

RSpec.describe Photo::GetHSBChannelStats do

  describe "A 3-colour image with black, white and blue" do
    let(:colour_data) { Photo::GetHistogramData.call('spec/files/photo_get_hsb_channel_stats/black_white_blue.png') }
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

  describe "A red image with hues at 5 degrees and 355 degrees" do
    let(:colour_data) { Photo::GetHistogramData.call('spec/files/photo_get_hsb_channel_stats/two_reds.png') }
    let(:stats)       { Photo::GetHSBChannelStats.call(colour_data[:colours]) }
    subject { stats.first }

    it "returns a hue mean of 360" do
      expect(subject[:mean]).to eq(360)
    end

    it "returns a deviation of 5" do
      expect(subject[:deviation]).to eq(5)
    end
  end

end


