require 'rails_helper'

RSpec.describe SearchController, :type => :controller do
  include ColourSupport
  before(:all) do
    create_some_colours_and_bins  
  end

  describe "POST :upload" do
    context "when passing in a cat photo" do
      before(:each) do
        catpic = fixture_file_upload(Rails.root.join('spec/files/cat.jpg'), 'image/jpg')
        post :upload, { photo: catpic }

      end

      it "responds with 200 OK status" do
        expect(response.status).to eq(200)
      end

      it "responds with JSON" do
        expect(JSON.parse(response.body).class).to eq(Array)
      end

      it "contains the right data" do
        data   = JSON.parse(response.body)
        
        expect(data).to be_a Array
        expect(data.first).to be_a Hash
        expect(data.first["type"]).to eq("common")
        expect(data.first["occurances"]).not_to be_nil

        expect(Colour.find(data.first["colour"]["id"])).to eq(Colour.find_by(label: 'Pale brown'))
      end
    end

    context "when not passing in any parameters" do
      before(:each) do
        post :upload
      end

      it "responds with 422 unprocessable entity status" do
        expect(response.status).to eq(422)
      end
    end

    context "when not passing in a photo" do
      before(:each) do
        nim = fixture_file_upload(Rails.root.join('spec/files/not_an_image.md'), 'document')
        post :upload, { photo: nim }
      end
      it "responds with 415 unsupported media type status" do
        expect(response.status).to eq(415)
      end
    end
  end

  describe "GET :show" do

  end
end
