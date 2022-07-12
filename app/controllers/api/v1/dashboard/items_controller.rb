class Api::V1::Dashboard::ItemsController < Api::V1::Dashboard::Base

  before_action :set_item, except: [:create, :index]

  has_scope :name_like, as: :name 
  has_scope :of_category_id, as: :category_id
  has_scope :only_cards, type: :boolean, as: :cards
  has_scope :has_discount, type: :boolean
  has_scope :paginate, using: %i[page per], type: :hash, allow_blank: true
  has_scope :of_ids, as: :ids, type: :array
  has_scope :order_by_best_sales, type: :boolean
  has_scope :order_by_high_price, type: :boolean
  has_scope :order_by_low_price, type: :boolean
  has_scope :order_by_recent, type: :boolean
  has_scope :empty_stock, type: :boolean
  has_scope :low_stock, type: :boolean
  has_scope :order_by_low_stock, type: :boolean
  has_scope :order_by_high_stock, type: :boolean
  has_scope :only_limited_stock, as: :limited_stock, type: :boolean
  has_scope :only_unlimited_stock, as: :unlimited_stock, type: :boolean

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
    @item = Item.visible.find(params.require(:id))
  end
end
