class Api::V1::Dashboard::ItemsController < Api::V1::Dashboard::Base
  include Scopes::Dashboard::ItemsScopes

  before_action :set_item, except: [:create, :index]

  apply_controller_scopes only: [:index]

  def index

    items= apply_scopes(Item.visible.include_categories.page(1))
    respond({
      items: serialize_resource(
                items,
                each_serializer: Dashboard::ItemSerializer,
                include: ['item_categories.category']
              ),
      pagination_details: pagination_details(items)
    })
  end

  def create
    item = Item::ItemCreation.new(items_params).create!
    respond(item)
  end

  def update
    updated_item = Item::ItemUpdate.new(@item).update!(items_params)
    respond(updated_item)
  end

  def delete
    destroyed_item = Item::ItemDestroy.new(@item).destroy!
    respond_ok
  end

  private
  def items_params
    params.require(:item).permit(
      :category_id,
      :type_name,
      :name,
      :price,
      :available,
      :has_limited_stock,
      :stock,
      :low_stock,
      :notify_on_low_stock,
      :code,
      :cost,
      :discount_price,
      :has_discount,
      :discount_end_date,
      :discount_start_date,
      :max_quantity_per_customer,
      :allow_multi_quantity,
      :allow_duplicate,
      :title,
      :sub_title,
      :hint,
      item_categories_attributes: [:id, :category_id, :_destroy]
    )
  end

  def set_item
    @item = Item.visible.find(params.require(:id))
  end
end
