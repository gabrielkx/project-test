class Api::RestaurantsController < Api::BaseController
  before_action :set_restaurant, only: [ :update, :destroy ]

  def index
    restaurants = if params[:name].present?
                    Restaurant.where("name ILIKE ?", "%#{params[:name]}%")
    else
                    Restaurant.all
    end

    render_success(restaurants)
  end

  def create
    restaurant = Restaurant.new(restaurant_params)

    if restaurant.save
      render_success(restaurant, status: :created)
    else
      render_validation_error(restaurant)
    end
  end

  def update
    if @restaurant.update(restaurant_params)
      render_success(@restaurant)
    else
      render_validation_error(@restaurant)
    end
  end

  def destroy
    @restaurant.destroy
    render_success({ message: "Restaurant deleted" })
  end

  private

  def restaurant_params
    params.require(:restaurant).permit(:name, menus_attributes: [ :name, menu_items_attributes: [ :name, :price ] ])
  end

  def set_restaurant
    @restaurant = Restaurant.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render_not_found("Restaurant not found")
  end
end
