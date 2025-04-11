require 'rails_helper'

RSpec.describe "Api::MenusController", type: :request do
  let!(:restaurant) { create(:restaurant) }
  let!(:menu) { create(:menu, restaurant: restaurant) }

  describe "GET /api/menus" do
    it "returns all menus" do
      get "/api/menus"
      expect(response).to have_http_status(:ok)
      expect(response.parsed_body).to be_an(Array)
    end

    it "filters by restaurant_id" do
      get "/api/menus", params: { restaurant_id: restaurant.id }

      expect(response).to have_http_status(:ok)
      expect(response.parsed_body.all? { |m| m["restaurant_id"] == restaurant.id }).to be true
    end
  end

  describe "POST /api/menus" do
    let(:valid_params) do
      {
        menu: {
          name: "Dinner Menu",
          restaurant_id: restaurant.id
        }
      }
    end

    it "creates a menu" do
      post "/api/menus", params: valid_params
      expect(response).to have_http_status(:created)
      expect(response.parsed_body["name"]).to eq("Dinner Menu")
    end

    it "returns validation error if name is missing" do
      post "/api/menus", params: { menu: { restaurant_id: restaurant.id } }
      expect(response).to have_http_status(:unprocessable_entity)
    end
  end

  describe "PUT /api/menus/:id" do
    it "updates the menu" do
      put "/api/menus/#{menu.id}", params: { menu: { name: "Updated Menu" } }
      expect(response).to have_http_status(:ok)
      expect(response.parsed_body["name"]).to eq("Updated Menu")
    end

    it "returns 404 if menu not found" do
      put "/api/menus/999999", params: { menu: { name: "Fail" } }
      expect(response).to have_http_status(:not_found)
    end
  end

  describe "DELETE /api/menus/:id" do
    it "deletes the menu" do
      expect {
        delete "/api/menus/#{menu.id}"
      }.to change(Menu, :count).by(-1)

      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)["message"]).to eq("Menu deleted")
    end

    it "returns not found for invalid id" do
      delete "/api/menus/999999"

      expect(response).to have_http_status(:not_found)
      expect(JSON.parse(response.body)["error"]).to eq("Menu not found")
    end
  end
end
