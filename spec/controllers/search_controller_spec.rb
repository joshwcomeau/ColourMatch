require 'rails_helper'

RSpec.describe SearchController, :type => :controller do
  before(:all) do
    Colour.create([
    {
      rgb:   { r: 169, g: 169, b: 169},
      label: "Dark gray"
    }, {
      rgb:   { r: 201, g: 192, b: 187},
      label: "Pale silver"
    }, {
      rgb:   { r: 190, g: 190, b: 190},
      label: "Gray (X11 gray)"
    }, {
      rgb:   { r: 220, g: 220, b: 220},
      label: "Gainsboro"
    }, {
      rgb:   { r: 0,   g: 122, b: 165},
      label: "CG Blue"
    }, {
      rgb:   { r: 230, g: 232, b: 250},
      label: "Glitter"
    }, {
      rgb:   { r: 245, g: 245, b: 245},
      label: "White smoke"
    }, {
      rgb:   { r: 85,  g: 107, b: 47 },
      label: "Dark olive green"
    }])
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
        # Breaking the rule of one-expect-per-spec, because each spec involves a fair bit of processing.
        # Should save significant time by bundling them.
        data   = JSON.parse(response.body)
        colors = data.map { |c| c["label"] }

        expect(data.count).to eq(6)
        
        expect(colors).to eq(["Dark gray", "Pale silver", "Gray (X11 gray)", "Gainsboro", "CG Blue", "Glitter"])
        expect(colors).not_to include("White smoke")
        expect(colors).not_to include("Dark olive green")
        expect(colors).not_to include(nil)

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
