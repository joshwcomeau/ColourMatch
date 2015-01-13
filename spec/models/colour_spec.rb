# == Schema Information
#
# Table name: colours
#
#  id         :integer          not null, primary key
#  label      :string(255)
#  created_at :datetime
#  updated_at :datetime
#  hex        :string(255)
#  lab        :json
#  rgb        :json
#  bin_id     :integer
#  hsb        :json
#

require 'rails_helper'

RSpec.describe Colour, :type => :model do

  # NOTE
  # All of the business logic takes place in service objects.
  # Therefore, the bulk of the tests for photos are in spec/services/photo

  describe "valid" do

    let(:colour) { create(:colour) }

    subject { colour }

    it { is_expected.to be_valid }
    it { is_expected.to be_persisted }

    describe "rgb value" do
      subject { colour.rgb }
      it { is_expected.not_to be_empty }
      it { is_expected.to be_a Hash  }
      
      it "has an r key" do
        expect(subject.key?('r')).to eq(true)
      end

      it "has an g key" do
        expect(subject.key?('g')).to eq(true)
      end

      it "has an b key" do
        expect(subject.key?('b')).to eq(true)
      end
    end
    
    describe "hex value" do
      subject { colour.hex }
      it { is_expected.not_to be_empty }
      it { is_expected.to be_a String  }
      it { is_expected.to eq('76FF7A') }
    end
  end
end

