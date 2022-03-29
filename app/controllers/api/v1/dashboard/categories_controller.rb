class Api::V1::Dashboard::CategoriesController < Api::V1::Dashboard::Base

  before_action :set_category, except: [:index,:create]

  def index
    categories = Category.all
    respond(categories: categories)
  end

  def create
    category = Category.new(categories_params)
    category.save!
    respond(category)
  end

  def update
    @category.update!(categories_params)
    respond(@category)
  end

  def destroy
    @category.destroy!
    respond_ok
  end

  private
  def categories_params
    params.require(:category).permit(:name, :primary_category_id)
  end

  def set_category
    @category = Category.find(params[:id])
  end
end