FactoryBot.define do
  factory :menu_item do
    name { "Item Name" }
    price { 9.99 }
    menu
  end
end
