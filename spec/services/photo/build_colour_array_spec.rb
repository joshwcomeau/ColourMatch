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

    let(:outliers) { Photo::ExtractOutliers.call(colour_data_hires)           } 
    let(:commons)  { Photo::ExtractMostCommonColours.call(colour_data_lores)  }

    it "contains an 'outliers' array" do
      expect(outliers).to be_a Array
    end

    it "contains a 'commons' array" do
      expect(commons).to be_a Array
    end
    
    describe "outliers" do
      subject { outliers.first }

      it { is_expected.to include(type:             'outlier')                        }
      it { is_expected.to include(colour:           Colour.find_by(label: 'Tangelo')) }
      it { is_expected.to include(occurances:       2200)                             }
      it { is_expected.to include(coverage:         7)                                }
      it { is_expected.to include(outlier_channel:  :s)                               }
      it { is_expected.to include(z_score:          3.3553043810357237)               }
    end

    describe "commons" do
      subject { commons.first }

      it { is_expected.to     include(type:       'common')                                 }
      it { is_expected.to     include(colour:     Colour.find_by(label: 'Bright lavender')) }
      it { is_expected.to     include(occurances: 22554)                                    }
      it { is_expected.to     include(coverage:   75)                                       }
      it { is_expected.not_to include(:outlier_channel)                                     }
      it { is_expected.not_to include(:z_score)                                             }
    end
  
    describe "original colour" do
      subject { commons.first[:original_colour] }

      it { is_expected.not_to be_nil      }
      it { is_expected.to include(r: 194) }
      it { is_expected.to include(g: 152) }
      it { is_expected.to include(b: 227) }
    end
  end
end

