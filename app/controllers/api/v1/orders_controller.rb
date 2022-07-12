class Api::V1::OrdersController < ApplicationController
  before_action :authenticate_user

  has_scope :only_cards, type: :boolean , as: :cards, only: [:index]
  has_scope :paginate, using: %i[page per], type: :hash, allow_blank: true, only: [:index]
  has_scope :delivered, type: :boolean, only: [:index]
  has_scope :pending_delivery, type: :boolean, only: [:index]
  has_scope :failed_delivery, type: :boolean, only: [:index]
  has_scope :order_by_recent, type: :boolean, only: [:index]
  has_scope :of_ids, as: :id
  
  def index
    orders= apply_scopes(Current.user.orders.fullfilled)
    data= {order: serialize_resource(orders)}
    if pagination_details(orders)
      data[:pagination_details] = pagination_details(orders)
    end
    respond(data)
  end

  # def create
  #   order = Order.new(cart: Current.user.get_full_cart)
  #   order.save!

  #   # TODO: Background job to destroy the order if not finished 
  #   respond(order)
  # end

  def create
    order = Order::OrderCreation.new(Current.user.get_full_cart)
                                .create!
    respond(order)
  end
end