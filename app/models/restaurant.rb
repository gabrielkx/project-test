class Restaurant < ApplicationRecord
  has_many :menus
  has_many :menu_items, through: :menus

  accepts_nested_attributes_for :menus

  validates :name, presence: true, uniqueness: true
end
