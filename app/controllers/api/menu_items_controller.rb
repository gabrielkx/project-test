class Api::MenuItemsController < Api::BaseController
  before_action :set_menu_item, only: %i[update destroy]

  def index
    menu_items = MenuItem.all
    menu_items = menu_items.where(menu_id: params[:menu_id]) if params[:menu_id].present?

    render_success(menu_items)
  end

  def create
    menu_item = MenuItem.new(menu_item_params)

    if menu_item.save
      render_success(menu_item, status: :created)
    else
      render_validation_error(menu_item)
    end
  end

  def update
    if @menu_item.update(menu_item_params)
      render_success(@menu_item)
    else
      render_validation_error(@menu_item)
    end
  end

  def destroy
    @menu_item.destroy
    render_success({ message: "Menu item deleted" })
  end

  private

  def set_menu_item
    @menu_item = MenuItem.find_by(id: params[:id])
    render_not_found("Menu item not found") unless @menu_item
  end

  def menu_item_params
    params.require(:menu_item).permit(:name, :price, :menu_id)
  end
end
