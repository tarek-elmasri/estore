class Api::V1::Dashboard::CategoriesController < Api::V1::Dashboard::Base

  before_action :find_record, except: [:create]

  def create
    return respond_forbidden unless Current.user.is_authorized_to_create_category?
    
    category = Category.new(categories_params)
    if category.save
      Current.user.staff_actions.create(action: :create_category, model: :category, model_id: category.id)
      respond(category)
    else
      respond_unprocessable(category.errors)
    end
  end

  def update
    return respond_forbidden unless Current.user.is_authorized_to_update_category?
    if @category.update(categories_params)
      Current.user.staff_actions.create(action: :update_category, model: :category, model_id: @category.id)
      respond(@category)
    else
      respond_unprocessable(@category.errors)
    end
  end

  def destroy
    return respond_forbidden unless Current.user.is_authorized_to_delete_category?
    if @category.destroy
      Current.user.staff_actions.create(action: :delete_category, model: :category, model_id: @category.id)
      respond_ok
    else
      respond_unprocessable(@category.errors)
    end
  end

  private
  def categories_params
    params.require(:category).permit(:name)
  end

  def find_record
    @category = Category.find_by(id: params[:id])
    respond_not_found unless @category
  end
end