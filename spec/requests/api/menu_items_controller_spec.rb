require "rails_helper"

RSpec.describe "Api::MenuItemsController", type: :request do
  let!(:restaurant) { create(:restaurant) }
  let!(:menu) { create(:menu, restaurant: restaurant) }
  let!(:menu2) { create(:menu, restaurant: restaurant, name: "Menu 2") }

  describe "GET /api/menu_items" do
    let!(:menu_item1) { create(:menu_item, name: "Feijoada", menu: menu) }
    let!(:menu_item2) { create(:menu_item, name: "Moqueca", menu: menu2) }

    it "returns all menu items" do
      get "/api/menu_items"
      expect(response).to have_http_status(:ok)
      expect(response.body).to include(menu_item1.name)
      expect(response.body).to include(menu_item2.name)
    end

    it "filters by menu_id" do
      get "/api/menu_items", params: { menu_id: menu.id }
      expect(response).to have_http_status(:ok)
      expect(response.body).to include(menu_item1.name)
      expect(response.body).not_to include(menu_item2.name)
    end
  end

  describe "POST /api/menu_items" do
    it "creates a new menu item" do
      post "/api/menu_items", params: {
        menu_item: {
          name: "Ceviche",
          price: 42.00,
          menu_id: menu.id
        }
      }

      expect(response).to have_http_status(:created)
      expect(response.body).to include("Ceviche")
    end

    it "returns error with invalid params" do
      post "/api/menu_items", params: {
        menu_item: { name: "", price: "", menu_id: nil }
      }

      expect(response).to have_http_status(:unprocessable_entity)
    end
  end

  describe "PATCH /api/menu_items/:id" do
    let!(:menu_item) { create(:menu_item, menu: menu) }

    it "updates the menu item" do
      patch "/api/menu_items/#{menu_item.id}", params: {
        menu_item: { name: "Updated Item" }
      }

      expect(response).to have_http_status(:ok)
      expect(response.body).to include("Updated Item")
    end

    it "returns error for invalid data" do
      patch "/api/menu_items/#{menu_item.id}", params: {
        menu_item: { name: "" }
      }

      expect(response).to have_http_status(:unprocessable_entity)
    end

    it "returns not found for invalid id" do
      patch "/api/menu_items/999999", params: {
        menu_item: { name: "Any" }
      }

      expect(response).to have_http_status(:not_found)
    end
  end

  describe "DELETE /api/menu_items/:id" do
    let!(:menu_item) { create(:menu_item, menu: menu) }

    it "deletes the menu item" do
      delete "/api/menu_items/#{menu_item.id}"

      expect(response).to have_http_status(:ok)
      expect(response.body).to include("Menu item deleted")
    end

    it "returns not found if the menu item does not exist" do
      delete "/api/menu_items/999999"

      expect(response).to have_http_status(:not_found)
    end
  end
end
