class Importer::Restaurant < Importer::Base
  def run
    ActiveRecord::Base.transaction do
      parse(@file)
    end
  end

  private

  def parse(data)
    data["restaurants"].map do |restaurant_data|
      process_restaurant(restaurant_data)
    end
  end

  def process_restaurant(data)
    restaurant = Restaurant.find_or_create_by!(name: data["name"])

    Array(data["menus"]).each do |menu_data|
      menu = process_menu(restaurant, menu_data)
      process_menu_items(menu, menu_data)
    end

    restaurant
  end

  def process_menu(restaurant, menu_data)
    Menu.find_or_create_by!(
      restaurant: restaurant,
      name: menu_data["name"]
    )
  end

  def process_menu_items(menu, menu_data)
    items = menu_data["menu_items"] || menu_data["dishes"] || []

    Array(items).each do |item_data|
      MenuItem.find_or_create_by!(
        menu: menu,
        name: item_data["name"]
      ) do |item|
        item.price = item_data["price"].to_d
      end
    end
  end
end
