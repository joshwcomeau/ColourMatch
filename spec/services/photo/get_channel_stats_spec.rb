require 'rails_helper'

RSpec.describe Photo::GetChannelStats do

  describe "A 3-colour image with black, white and blue" do
    let(:colour_data) { Photo::GetHistogramData.call('spec/files/photo_get_hsb_channel_stats/black_white_blue.png') }
    let(:stats)       { Photo::GetChannelStats.call(colour_data[:colours]) }

    it "returns a hash" do
      binding.pry
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
        # values [0, 0, 201]
        subject { stats[:hsb][:hue] }

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
        subject { stats[:hsb][:saturation] }

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
        subject { stats[:hsb][:brightness] }

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
  end

  # describe "A red image with hues at 5 degrees and 355 degrees" do
  #   let(:colour_data) { Photo::GetHistogramData.call('spec/files/photo_get_hsb_channel_stats/two_reds.png') }
  #   let(:stats)       { Photo::GetChannelStats.call(colour_data[:colours]) }
  #   subject { stats.first }

  #   it "returns a hue mean of 360" do
  #     expect(subject[:mean]).to eq(360)
  #   end

  #   it "returns a deviation of 5" do
  #     expect(subject[:deviation]).to eq(5)
  #   end
  # end

end


