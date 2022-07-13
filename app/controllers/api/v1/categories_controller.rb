class Api::V1::CategoriesController < ApplicationController
  include Scopes::CategoriesScopes

  apply_controller_scopes 

  def index
    categories =  apply_scopes(Category.page(1))
    respond({
      categories: serialize_resource(
                    categories,
                    include: ['sub_categories.sub_categories']
                  ),
      pagination_details: pagination_details(categories)
    })
  end
end