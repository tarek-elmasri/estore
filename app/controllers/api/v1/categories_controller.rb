class Api::V1::CategoriesController < ApplicationController
  
  has_scope :primary, type: :boolean, default: true
  has_scope :name_like, as: :name
  has_scope :paginate, using: %i[page per], type: :hash, allow_blank: true
  has_scope :of_ids, as: :id
  
  def index
    categories =  apply_scopes(Category.page(1))
    respond({
      categories: serialize_resource(
                    categories,
                    include: ['sub_categories.sub_categories'],
                    each_serializer: CategorySerializer
                  ),
      pagination_details: pagination_details(categories)
    })
  end
end