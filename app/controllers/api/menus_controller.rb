class Api::MenusController < Api::BaseController
  before_action :set_menu, only: [ :update, :destroy ]

  def index
    menus = Menu.all
    menus = menus.where(restaurant_id: params[:restaurant_id]) if params[:restaurant_id].present?

    render_success(menus)
  end

  def create
    menu = Menu.new(menu_params)

    if menu.save
      render_success(menu, status: :created)
    else
      render_validation_error(menu)
    end
  end

  def update
    if @menu.update(menu_params)
      render_success(@menu)
    else
      render_validation_error(@menu)
    end
  end

  def destroy
    render_success({ message: "Menu deleted" }) if @menu.destroy
  end

  private

  def set_menu
    @menu = Menu.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render_not_found("Menu not found")
  end

  def menu_params
    params.require(:menu).permit(:name, :restaurant_id, menu_items_attributes: [ :id, :name, :price, :_destroy ])
  end
end
