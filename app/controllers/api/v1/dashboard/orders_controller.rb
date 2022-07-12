class Api::V1::Dashboard::OrdersController < Api::V1::Dashboard::Base

  before_action :authorize_show , only: [:index]

  has_scope :only_cards, type: :boolean , as: :cards
  has_scope :paginate, using: %i[page per], type: :hash, allow_blank: true
  has_scope :delivered, type: :boolean
  has_scope :pending_delivery, type: :boolean
  has_scope :failed_delivery, type: :boolean
  has_scope :order_by_recent, type: :boolean
  
  def index
    orders= apply_scopes(Order.fullfilled.include_order_items.page(1))

    respond({
      orders: serialize_resource(
      orders,
      each_serializer: Dashboard::OrderSerializer
      ),
      pagination_details: pagination_details(orders)
    })
  end



  def authorize_show
    raise Errors::Unauthorized unless Current.user.is_authorized_to_show_orders?
  end

end