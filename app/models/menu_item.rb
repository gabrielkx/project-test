class MenuItem < ApplicationRecord
  belongs_to :menu

  validates :name, uniqueness: true
end
