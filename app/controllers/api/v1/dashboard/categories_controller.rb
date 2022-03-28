class Api::V1::Dashboard::CategoriesController < Api::V1::Dashboard::Base

  before_action :set_category, except: [:create]

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
    @category = Category.find(id: params[:id])
  end
end