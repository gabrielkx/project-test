require 'rails_helper'

RSpec.describe Restaurant, type: :model do
  describe 'associations' do
    it { should have_many(:menus) }
    it { should have_many(:menu_items).through(:menus) }
  end

  describe 'validations' do
    subject { create(:restaurant) }

    it { should validate_presence_of(:name) }
    it { should validate_uniqueness_of(:name) }
  end

  describe 'nested attributes' do
    it 'accepts nested attributes for menus' do
      restaurant = Restaurant.new(
        name: 'Restaurante Teste',
        menus_attributes: [
          { name: 'Café da Manhã' },
          { name: 'Almoço' }
        ]
      )

      expect(restaurant.menus.size).to eq(2)
    end
  end
end
