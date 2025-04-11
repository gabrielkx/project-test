require 'rails_helper'

RSpec.describe Menu, type: :model do
  describe 'associations' do
    it { should belong_to(:restaurant) }
    it { should have_many(:menu_items).dependent(:destroy) }
  end

  describe 'validations' do
    subject { create(:menu) } # Garante validação de unicidade

    it { should validate_presence_of(:name) }
    it { should validate_uniqueness_of(:restaurant_id).scoped_to(:name) }
  end

  describe 'nested attributes' do
    it 'accepts nested attributes for menu_items' do
      restaurant = create(:restaurant)

      menu = Menu.new(
        name: 'Lunch',
        restaurant: restaurant,
        menu_items_attributes: [
          { name: 'Burger', price: 9.99 },
          { name: 'Fries', price: 4.99 }
        ]
      )

      expect(menu).to be_valid
      expect(menu.menu_items.size).to eq(2)
    end
  end
end
