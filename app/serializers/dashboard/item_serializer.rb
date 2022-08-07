class Dashboard::ItemSerializer < ActiveModel::Serializer

  attributes :id, :name , :type_name, :price, :active_stock, :pending_stock , :sold_quantity, :cost, :image_url

  has_many :item_categories, serializer: Dashboard::ItemCategorySerializer

  def image
    object.image.url(expires_in: 30.minutes)
  end
end