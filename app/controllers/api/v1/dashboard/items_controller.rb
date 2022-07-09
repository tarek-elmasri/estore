class Api::V1::Dashboard::ItemsController < Api::V1::Dashboard::Base

  before_action :set_item, except: [:create]

  def create
    # create is used to allow passing nested parameter atttributes
    item = Item::ItemCreation.new(items_params).create!
    respond(item)
  end

  def update
    updated_item = Item::ItemUpdate.new(@item).update!(items_params)
    # @item.update!(items_params.except(:type_name))
    respond(updated_item)
  end

  def delete
    destroyed_item = Item::ItemDestroy.new(@item).destroy!
    # @item.terminate!
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
    @item = Item.visible.find(id: params.require(:id))
  end
end
