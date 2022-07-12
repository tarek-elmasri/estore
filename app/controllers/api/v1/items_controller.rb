class Api::V1::ItemsController < ApplicationController

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
  #has_scope :empty_stock, type: :boolean
  has_scope :low_stock, type: :boolean
  #has_scope :order_by_low_stock, type: :boolean
  #has_scope :order_by_high_stock, type: :boolean
  #has_scope :only_limited_stock, as: :limited_stock, type: :boolean
  #has_scope :only_unlimited_stock, as: :unlimited_stock, type: :boolean



  def index
    # to include scope params later
    items= apply_scopes(Item.available.page(1))
    respond({
      items: serialize_resource(items),
      pagination_details: pagination_details(items)
    })
  end



end