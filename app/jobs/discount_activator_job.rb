class DiscountActivatorJob < ApplicationJob
  queue_as :default

  def perform(item_id, mode)
    item = Item.find_by(id: item_id)
    return unless item
    mode == :activate ?
        activate(item) : deactivate(item)
  end


  private
  def activate(item)
    return if item.has_discount?
    return unless item.discount_start_date? || item.discount_end_date?
    return if item.discount_start_date > DateTime.now
    return if item.discount_end_date < DateTime.now
    
    Item::ItemUpdate.new(item).update_discount_status!(true)
  end

  def deactivate(item)
    return unless item.has_discount?
    return unless item.discount_end_date?
    return if item.discount_end_date > DateTime.now

    Item::ItemUpdate.new(item).update_discount_status!(false)

  end
end
