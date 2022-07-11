class Api::V1::CategoriesController < ApplicationController
  

  def index
    # e3447d0c-7e0e-4a1e-b725-fb2f94d7e1b9
    categories =  Category.primary.all
    respond({
      categories: serialize_resource(
                    categories,
                    each_serializer: CategorySerializer
                  )
    })
  end
end