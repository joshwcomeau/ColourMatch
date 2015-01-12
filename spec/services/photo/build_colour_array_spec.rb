require 'rails_helper'
require 'initial_colour_setup'


RSpec.describe Photo::BuildColourArray do
  include InitialColourSetup

  before(:all) do 
    reset_a_few_colours
  end

  context "when provided 'extract_most_common_colours_test_image.png'" do
    let(:colour_data_hires) do
      Photo::GetHistogramData.call(
        'spec/files/build_colour_array_test_image.png', 
        colours: Photo::CreatePaletteFromPhoto::HIRES
      ) 
    end
    let(:colour_data_lores) do 
      Photo::GetHistogramData.call(
        'spec/files/build_colour_array_test_image.png', 
        colours: Photo::CreatePaletteFromPhoto::LORES
      ) 
    end

    let(:stats)    { Photo::GetChannelStats.call(colour_data_hires[:colours])  }
    let(:outliers) { Photo::ExtractOutliers.call(colour_data_hires, stats)        } 
    let(:commons)  { Photo::ExtractMostCommonColours.call(colour_data_lores)      }

    it "contains an 'outliers' array" do
      expect(outliers).to be_a Array
    end

    it "contains a 'commons' array" do
      expect(commons).to be_a Array
    end
    
    describe "outliers" do
      subject { outliers.first }

      it { is_expected.to include(type:             'outlier')                        }
      it { is_expected.to include(closest:          Colour.find_by(label: 'Tangelo')) }
      it { is_expected.to include(occurances:       2200)                             }
      it { is_expected.to include(coverage:         7)                                }
      it { is_expected.to include(outlier_channel:  "Saturation")                     }
      it { is_expected.to include(z_score:          3.36)               }
    end

    describe "commons" do
      subject { commons.first }

      it { is_expected.to     include(type:       'common')                                 }
      it { is_expected.to     include(closest:    Colour.find_by(label: 'Bright lavender')) }
      it { is_expected.to     include(occurances: 22554)                                    }
      it { is_expected.to     include(coverage:   75)                                       }
      it { is_expected.not_to include(:outlier_channel)                                     }
      it { is_expected.not_to include(:z_score)                                             }

      describe "colour" do
        subject { commons.first[:colour] }

        it { is_expected.to     include(rgb: {r: 194, g: 152, b: 227})                        } 
        it { is_expected.to     include(hex: "C298E3")                                        }
      end
    end
  
  end
end

