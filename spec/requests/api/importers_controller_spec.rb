require 'rails_helper'

RSpec.describe "Api::ImportersController", type: :request do
  describe "POST /importers/restaurant" do
    let(:json_file) do
      Tempfile.new([ 'restaurants', '.json' ]).tap do |f|
        f.write({
          restaurants: [
            {
              name: "Boteco do Zé",
              menus: [
                {
                  name: "Almoço",
                  menu_items: [
                    { name: "Feijoada", price: 29.99 },
                    { name: "Bife à Cavalo", price: 24.50 }
                  ]
                }
              ]
            }
          ]
        }.to_json)
        f.rewind
      end
    end

    let(:uploaded_file) do
      Rack::Test::UploadedFile.new(json_file.path, 'application/json')
    end

    after do
      json_file.close
      json_file.unlink
    end

    it "imports the data and returns success" do
      post "/api/importers/restaurant", params: { json_file: uploaded_file }

      expect(response).to have_http_status(:created)

      expect(Restaurant.count).to eq(1)
      expect(Menu.count).to eq(1)
      expect(MenuItem.count).to eq(2)

      json = JSON.parse(response.body)
      expect(json).to be_a(Hash)
    end

    it "returns 400 if no file is uploaded" do
      post "/api/importers/restaurant"

      expect(response).to have_http_status(:bad_request)
      expect(response.body).to include("No file uploaded")
    end

    it "returns 400 for invalid JSON" do
      bad_file = Tempfile.new([ 'invalid', '.json' ])
      bad_file.write("{invalid json")
      bad_file.rewind

      post "/api/importers/restaurant", params: {
        json_file: Rack::Test::UploadedFile.new(bad_file.path, 'application/json')
      }

      expect(response).to have_http_status(:internal_server_error)
      expect(response.body).to include("Invalid JSON file")

      bad_file.close
      bad_file.unlink
    end
  end
end
