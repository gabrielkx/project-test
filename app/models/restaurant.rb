class Restaurant < ApplicationRecord
  has_many :menus, dependent: :destroy
  has_many :menu_items, through: :menus, dependent: :destroy

  accepts_nested_attributes_for :menus

  validates :name, presence: true, uniqueness: true
end
