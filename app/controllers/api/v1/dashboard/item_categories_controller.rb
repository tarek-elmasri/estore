class Api::v1::Dashboard::ItemCategoriesController < Api::V1::Dashboard::Base

  def create

    respond_forbidden unless Current.user.is_authorized_to_create_item_category?
    ic= ItemCategory.new(item_categories_params)
    if ic.save
      respond({item_category: ic})
    else
      respond_unprocessable(ic.errors)
    end
  end

  def destroy
    respond_forbidden unless Current.user.is_authorized_to_delete_item_category?

    ic= ItemCategory.find_by_id(params[:id])
    respond_not_found unless ic
    ic.destroy
    respond_ok
  end

  private

  def item_categories_params
    params.require(:item_category).permit(:item_id, :category_id)
  end
end