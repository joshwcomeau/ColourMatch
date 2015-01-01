require 'rails_helper'

RSpec.describe Photo::FilterColoursByOccurance do

  let(:colour_data) { Photo::GetHistogramData.call('spec/files/filter_test_image.png') }
  let(:filtered_data) { Photo::FilterColoursByOccurance.call(colour_data) }

  it "initially contains 9 colours" do
    expect(colour_data[:colours].count).to eq(9)
  end

  it "filters down to 7 colours" do
    expect(filtered_data.count).to eq(7)
  end


end


