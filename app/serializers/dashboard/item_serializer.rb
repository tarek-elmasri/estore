class Dashboard::ItemSerializer < ActiveModel::Serializer

  attributes :id, :name , :type_name, :price, :active_stock,
              :pending_stock , :sold_quantity, 
              :cost, :image, :available,
              :has_discount, :discount_start_date,
              :discount_end_date, :allow_multi_quantity, :allow_duplicate,
              :title, :sub_title, :hint, :pinned,
              :notify_on_low_stock, :low_stock
 

  has_many :item_categories, serializer: Dashboard::ItemCategorySerializer

  def image
    object.image_url
  end
end