class Api::V1::Dashboard::ItemsController < Api::V1::Dashboard::Base

  before_action :find_record, except: [:create]

  def create

    item = Item.new(items_params)
    item.save!
    Current.user.staff_actions.create(action: :create_item, model: :item, model_id: item.id)
    respond(item)
  end

  def update
    @item.update(items_params)
    Current.user.staff_actions.create(action: :update_item, model: :item, model_id: @item.id)
    respond(@item)
  end

  def destroy
    @item.destroy!
    Current.user.staff_actions.create(action: :delete_item, model: :item, model_id: @item.id)
    respond_ok
  end

  private
  def items_params
    params.require(:item).permit(
      :category_id,
      :type,
      :name,
      :price,
      :has_limited_stock,
      :stock,
      :low_stock,
      :notify_on_low_stock,
      :visible,
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
      :hint
    )
  end

  def find_record
    @item = Item.find(id: params[:id])
  end
end
