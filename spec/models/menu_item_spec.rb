require 'rails_helper'

RSpec.describe MenuItem, type: :model do
  describe 'associations' do
    it { should belong_to(:menu) }
  end

  describe 'validations' do
    subject { create(:menu_item) }

    it { should validate_presence_of(:name) }
    it { should validate_numericality_of(:price).is_greater_than(0) }
    it { should validate_uniqueness_of(:menu_id).scoped_to(:name) }
  end
end
