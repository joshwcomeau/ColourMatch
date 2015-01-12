require 'rails_helper'
require 'initial_colour_setup'

RSpec.describe PhotosController, :type => :controller do
  include InitialColourSetup
  before(:all) do 
    reset_a_few_colours
  end

  describe "POST :create" do
    context "when passing in a cat photo" do
      before(:each) do
        catpic = fixture_file_upload(Rails.root.join('spec/files/cat.jpg'), 'image/jpg')
        post :create, { photo: catpic }

      end

      it "responds with 200 OK status" do
        expect(response.status).to eq(200)
      end

      it "responds with JSON" do
        expect(JSON.parse(response.body).class).to eq(Hash)
      end

      it "contains the right data" do
        data   = JSON.parse(response.body)
        
        # Breaking the one-expect-per-spec rule because these specs are expensive.
        expect(data["colours"]).to be_a Array
        expect(data["colours"].first).to be_a Hash
        expect(data["colours"].first["outlier"]).to eq(false)
        expect(data["colours"].first["coverage"]).to be >= data["colours"].second["coverage"]
        expect(Colour.find(data["colours"].first["closest_colour_id"])).to be_a Colour

        expect(data["stats"]).to be_a Hash
        expect(data["stats"]["hsb"]).to be_a Hash
        expect(data["stats"]["lab"]).to be_a Hash
        expect(data["stats"]["hsb"]["h"]).to be_a Hash
        expect(data["stats"]["hsb"]["h"]["mean"]).to be_a Float
        expect(data["stats"]["hsb"]["h"]["deviation"]).to be_a Float
        expect(data["stats"]["lab"]["l"]["mean"]).to be_a Float
        expect(data["stats"]["lab"]["l"]["deviation"]).to be_a Float

      end
    end

    context "when not passing in any parameters" do
      before(:each) do
        post :create
      end

      it "responds with 422 unprocessable entity status" do
        expect(response.status).to eq(422)
      end
    end

    context "when not passing in a markdown file" do
      before(:each) do
        nim = fixture_file_upload(Rails.root.join('spec/files/not_an_image.md'), 'document')
        post :create, { photo: nim }
      end
      it "responds with 415 unsupported media type status" do
        expect(response.status).to eq(415)
      end
    end

    context "when not passing in an SVG" do
      before(:each) do
        nim = fixture_file_upload(Rails.root.join('spec/files/an_svg.svg'), 'image/svg+xml')
        post :create, { photo: nim }
      end
      it "responds with 415 unsupported media type status" do
        expect(response.status).to eq(415)
      end
    end

  end

  describe "GET :show" do

  end
end
