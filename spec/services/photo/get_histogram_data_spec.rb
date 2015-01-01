require 'rails_helper'

RSpec.describe Photo::GetHistogramData do

  context "when given 'colours_for_testing' with all default options" do
    let(:colour_data) { Photo::GetHistogramData.call('spec/files/colours_for_testing.png') }

    it "returns a hash" do
      expect(colour_data).to be_a Hash
    end

    it "preserves the image's width" do
      expect(colour_data[:width]).to eq(1000)
    end

    it "preserves the image's height" do
      expect(colour_data[:height]).to eq(600)
    end

    it "calculates the number of pixels" do
      expect(colour_data[:pixels]).to eq(600_000)
    end

    it "contains an array of colours" do
      expect(colour_data[:colours]).to be_a Array
    end

    describe "colour_data[:colours].first" do
      subject { colour_data[:colours].first }

      it { is_expected.to be_a Hash }
      it { is_expected.to include(:occurances) }
      it { is_expected.to include(rgb: { r: 255, g: 156, b: 0  }) }
      it { is_expected.to include(hsb: { h: 37, s: 100, b: 100 }) }
      it { is_expected.to include(lab: { l: 72.91620693323767, a: 28.616305417208665, b: 77.65226881876565 }) }
    end

    it "orders them by occurance" do
      expect(colour_data[:colours].first[:occurances]).to  be > colour_data[:colours].second[:occurances]
      expect(colour_data[:colours].second[:occurances]).to be > colour_data[:colours].third[:occurances]
    end    

    it "includes all 7 colours in the image" do
      expect(colour_data[:colours].count).to eq(7)
    end   
  
  end
end


