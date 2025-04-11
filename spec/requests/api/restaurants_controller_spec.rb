require 'rails_helper'

RSpec.describe "Api::Restaurants", type: :request do
  let(:headers) { { "Content-Type" => "application/json" } }

  describe "GET /api/restaurants" do
    let!(:restaurant1) { create(:restaurant, name: "Pizzaria Maravilha") }
    let!(:restaurant2) { create(:restaurant, name: "Churrasquinho do Zé") }

    it "returns all restaurants" do
      get "/api/restaurants"

      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body).size).to eq(2)
    end

    it "filters by name (case insensitive, partial match)" do
      get "/api/restaurants", params: { name: "pizzaria" }

      json = JSON.parse(response.body)
      expect(response).to have_http_status(:ok)
      expect(json.size).to eq(1)
      expect(json.first["name"]).to eq("Pizzaria Maravilha")
    end
  end

  describe "POST /api/restaurants" do
    let(:valid_payload) do
      {
        restaurant: {
          name: "Novo Restaurante",
          menus_attributes: [
            {
              name: "Menu do Dia",
              menu_items_attributes: [
                { name: "Feijoada", price: 35.50 },
                { name: "Salada", price: 18.00 }
              ]
            }
          ]
        }
      }.to_json
    end

    it "creates a new restaurant with nested menus and items" do
      expect {
        post "/api/restaurants", params: valid_payload, headers: headers
      }.to change(Restaurant, :count).by(1)
         .and change(Menu, :count).by(1)
         .and change(MenuItem, :count).by(2)

      expect(response).to have_http_status(:created)
    end

    it "returns validation error if name is missing" do
      payload = { restaurant: { name: "" } }.to_json

      post "/api/restaurants", params: payload, headers: headers

      expect(response).to have_http_status(:unprocessable_entity)
      expect(JSON.parse(response.body)["error"]).to include("Name can't be blank")
    end
  end

  describe "PATCH /api/restaurants/:id" do
    let!(:restaurant) { create(:restaurant, name: "Original") }

    it "updates the restaurant name" do
      patch "/api/restaurants/#{restaurant.id}", params: { restaurant: { name: "Atualizado" } }.to_json, headers: headers

      expect(response).to have_http_status(:ok)
      expect(restaurant.reload.name).to eq("Atualizado")
    end

    it "returns validation error on invalid update" do
      patch "/api/restaurants/#{restaurant.id}", params: { restaurant: { name: "" } }.to_json, headers: headers

      expect(response).to have_http_status(:unprocessable_entity)
      expect(JSON.parse(response.body)["error"]).to include("Name can't be blank")
    end
  end

  describe "DELETE /api/restaurants/:id" do
    let!(:restaurant) { create(:restaurant) }

    it "deletes the restaurant" do
      expect {
        delete "/api/restaurants/#{restaurant.id}"
      }.to change(Restaurant, :count).by(-1)

      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)["message"]).to eq("Restaurant deleted")
    end

    it "returns not found for invalid id" do
      delete "/api/restaurants/999999"

      expect(response).to have_http_status(:not_found)
      expect(JSON.parse(response.body)["error"]).to eq("Restaurant not found")
    end
  end
end
