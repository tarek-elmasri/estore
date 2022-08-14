class ItemSerializer < ActiveModel::Serializer
  attributes :id, :name , :type_name, :price, :has_stock, 
              :images, :has_discount, :discount_start_date,
              :discount_end_date, :discount_price, 
              :allow_duplicate, :allow_multi_quantity,
              :title, :sub_title, :hint, :pinned
              
  attribute :limited_stock ,if: :has_stock

  has_many :item_categories, serializer: ItemCategorySerializer

  def has_stock
    object.has_stock?
  end

  def limited_stock
    return false unless object.has_limited_stock
    return false if object.low_stock.blank?
    !object.has_stock?(object.low_stock)
  end

  def images
    object.images_data
  end
  
end