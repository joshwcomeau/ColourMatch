require 'rails_helper'

RSpec.describe Colour, :type => :model do

  describe "valid" do

    let(:colour) { create(:colour) }

    subject { colour }

    it { is_expected.to be_valid }
    it { is_expected.to be_persisted }
    
    describe "hex value" do
      subject { colour.hex }
      it { is_expected.not_to be_empty }
      it { is_expected.to be_a String  }
      it { is_expected.to eq('76FF7A') }
    end
  end

  describe "invalid" do
    let(:colour2) { create(:colour, g: nil)     }
    let(:colour3) { create(:colour, b: nil)     }
    let(:colour4) { create(:colour, label: nil) }
  end

  describe "missing a colour" do
    let(:colour) { build(:colour, r: nil) }

    subject { colour }

    it { is_expected.not_to be_valid }

    describe "error message" do
      before { colour.valid? } # Need to run this to generate the error messages.
      subject { colour.errors[:r] }

      it { is_expected.not_to be_empty }
      it { is_expected.to include("can't be blank") }
    end
  end

  describe "colour is below zero" do
    let(:colour) { build(:colour, g: -3) }
    before { colour.valid? }
    subject { colour.errors[:g] }

    it { is_expected.not_to be_empty }
    it { is_expected.to include("must be greater than or equal to 0") }
  end

  describe "colour is above 255" do
    let(:colour) { build(:colour, b: 256) }
    before { colour.valid? }
    subject { colour.errors[:b] }

    it { is_expected.not_to be_empty }
    it { is_expected.to include("must be less than or equal to 255") }
  end

  describe "colour isn't an integer" do
    let(:colour) { build(:colour, r: 12.345) }
    before { colour.valid? }
    subject { colour.errors[:r] }

    it { is_expected.not_to be_empty }
    it { is_expected.to include("must be an integer") }
  end

end

