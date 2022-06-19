class Api::V1::ItemsController < ApplicationController

  def index
    # to include scope params later
    items= Item.available.all
    respond(items)
  end



end