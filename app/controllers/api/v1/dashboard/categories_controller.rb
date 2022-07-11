class Api::V1::Dashboard::CategoriesController < Api::V1::Dashboard::Base

  before_action :set_category, except: [:index,:create]

  def index
    categories = Category.all
    respond({categories: 
      serialize_resource(
        categories, 
        each_serializer: Dashboard::CategorySerializer,
        include: ['sub_categories.sub_categories']
      )})
  end

  def create
    category = Category.::CategoryCreation.new(categories_params)
                                          .create!
    respond(category)
  end

  def update
    updated_category = Category::CategoryUpdate.new(@category)
                                              .update!(categories_params)
    respond(updated_category)
  end

  def delete
    Category::CategoryDestroy.new(@category).destroy!
    respond_ok
  end

  private
  def categories_params
    params.require(:category).permit(:name, :primary_category_id)
  end

  def set_category
    @category = Category.find(params.require(:id))
  end
end