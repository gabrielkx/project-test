require 'rails_helper'

RSpec.describe Importer::Restaurant do
  describe '#run' do
    let(:json_content) do
      {
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
      }.to_json
    end

    let(:uploaded_file) do
      Tempfile.new([ 'restaurants', '.json' ]).tap do |f|
        f.write(json_content)
        f.rewind
      end
    end

    after do
      uploaded_file.close
      uploaded_file.unlink
    end

    it 'imports restaurants, menus and menu items from a JSON file' do
      importer = Importer::Restaurant.new(file: uploaded_file)

      expect {
        importer.run
      }.to change { Restaurant.count }.by(1)
       .and change { Menu.count }.by(1)
       .and change { MenuItem.count }.by(2)

      restaurant = Restaurant.last
      expect(restaurant.name).to eq("Boteco do Zé")
      expect(restaurant.menus.first.name).to eq("Almoço")
      expect(restaurant.menus.first.menu_items.map(&:name)).to match_array([ "Feijoada", "Bife à Cavalo" ])
    end
  end
end
