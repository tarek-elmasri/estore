class Api::V1::ItemsController < ApplicationController

  has_scope :of_category_id, as: :category_id
  has_scope :only_cards, type: :boolean, as: :cards
  has_scope :has_discount, type: :boolean
  has_scope :paginate, using: %i[page per], type: :hash, allow_blank: true

  def index
    # to include scope params later
    items= apply_scopes(Item.available)
    data = {items: serialize_resource(items)}
    data[:pagination_details] = pagination_details(items) if pagination_details(items)
    respond(data)
  end



end