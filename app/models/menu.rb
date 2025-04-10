class Menu < ApplicationRecord
  belongs_to :restaurant

  has_many :menu_items, dependent: :destroy
  validates :name, presence: true
  validates :restaurant_id, uniqueness: { scope: :name }

  accepts_nested_attributes_for :menu_items
end
