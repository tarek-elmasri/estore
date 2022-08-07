class Api::V1::ItemsController < ApplicationController
  include Scopes::ItemsScopes

  apply_controller_scopes 

  def index
    items= apply_scopes(Item.available.page(1))
    respond({
      items: serialize_resource(items),
      pagination_details: pagination_details(items)
    })
  end



end