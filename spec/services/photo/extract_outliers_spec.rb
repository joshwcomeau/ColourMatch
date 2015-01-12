require 'rails_helper'
require 'initial_colour_setup'


RSpec.describe Photo::ExtractOutliers do
  include InitialColourSetup

  before(:all) do 
    reset_colours
    reset_bins
  end

  context "when provided 'outliers_for_testing.png'" do
    let(:colour_data) do 
      Photo::GetHistogramData.call(
        'spec/files/outliers_for_testing.png', 
        colours: Photo::CreatePaletteFromPhoto::HIRES
      ) 
    end
    let(:stats_data)  { Photo::GetChannelStats.call(colour_data[:colours]) }
    let(:results)     { Photo::ExtractOutliers.call(colour_data, stats_data) }

    it "returns an array" do
      expect(results).to be_a Array
    end

    describe "first outlier" do
      subject { results.first }

      it { is_expected.to include(closest: Colour.find_by(label: 'Pine green')) }
      it { is_expected.to include(type: "outlier")                              }
      it { is_expected.to include(occurances: 4582)                             }
      it { is_expected.to include(coverage: 2)                                  }
      it { is_expected.to include(outlier_channel: "Saturation")                }
      it { is_expected.to include(z_score: 5.02)                                }

      it "contains the right colour data" do
        expect(results.first[:colour]).to include(rgb: {r: 0, g: 115, b: 111})
        expect(results.first[:colour]).to include(hex: "00736F")
      end
    end

    describe "second outlier" do
      subject { results.second }

      it { is_expected.to include(closest: Colour.find_by(label: 'Pearl'))      }
      it { is_expected.to include(type: "outlier")                              }
      it { is_expected.to include(occurances: 1152)                             }
      it { is_expected.to include(coverage: 0)                                  }
      it { is_expected.to include(outlier_channel: "Brightness")                }
      it { is_expected.to include(z_score: 7.47)                                }
      
      it "contains the right colour data" do
        expect(results.second[:colour]).to include(rgb: {r: 231, g: 220, b: 199})
        expect(results.second[:colour]).to include(hex: "E7DCC7")
      end
    end
  end
end