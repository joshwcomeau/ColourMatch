require 'rails_helper'

RSpec.describe Photo::GetChannelStats do

  describe "A 3-colour image with black, white and blue" do
    let(:colour_data) { Photo::GetHistogramData.call('spec/files/photo_get_hsb_channel_stats/black_white_blue.png') }
    let(:stats)       { Photo::GetChannelStats.call(colour_data[:colours]) }

    it "returns a hash" do
      expect(stats).to be_a Hash
    end

    it "has an HSB key" do
      expect(stats.key? :hsb).to eq(true)
    end

    it "has a LAB key" do
      expect(stats.key? :lab).to eq(true)
    end

    describe "HSB" do
      describe "hue" do
        # values [201]
        # The idea here is we shouldn't consider hues whose brightness is an extreme. A red photo with near-black
        # blue shouldnt have a purple hue mean.

        subject { stats[:hsb][:h] }

        it { is_expected.to be_a Hash }

        it "returns the right stats" do
          expect(subject[:mean]).to eq(201)
          expect(subject[:deviation]).to eq(0)
        end
      end

      describe "saturation" do
        # values [0, 0, 50]
        subject { stats[:hsb][:s] }

        it { is_expected.to be_a Hash }

        it "returns the right stats" do
          expect(subject[:mean]).to eq(16.666666666666668)
          expect(subject[:deviation]).to eq(23.769134427076413)
        end
      end

      describe "brightness" do
        # values [0, 100, 50]
        subject { stats[:hsb][:b] }

        it { is_expected.to be_a Hash }

        it "returns the right stats" do
          expect(subject[:mean]).to eq(50)
          expect(subject[:deviation]).to eq(41.16934847963091)
        end
      end
    end
  end

  describe "A 3-colour image with black, white and grey" do
    let(:colour_data) { Photo::GetHistogramData.call('spec/files/photo_get_hsb_channel_stats/black_white_grey.png') }
    let(:stats)       { Photo::GetChannelStats.call(colour_data[:colours]) }

    describe "HSB" do
      describe "hue" do
        # values []
        subject { stats[:hsb][:h] }

        it "returns the right stats" do
          expect(subject[:mean]).to eq(0)
          expect(subject[:deviation]).to eq(0)
        end
      end

      describe "saturation" do
        # values [0, 0, 0]
        subject { stats[:hsb][:s] }

        it "returns the right stats" do
          expect(subject[:mean]).to eq(0)
          expect(subject[:deviation]).to eq(0)
        end
      end

      describe "brightness" do
        # values [0, 100, 50]
        subject { stats[:hsb][:b] }

        it "returns the right stats" do
          expect(subject[:mean]).to eq(50)
          expect(subject[:deviation]).to eq(41.16934847963091)
        end
      end
    end
  end
end


