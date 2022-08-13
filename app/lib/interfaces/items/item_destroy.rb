class Interfaces::Items::ItemDestroy
  include StaffTracker::Recorder

  attr_reader :item

  def initialize(item)
    self.item = item
  end

  def destroy!
    check_authorization
    check_cards
    self.item.visible = false
    self.item.available = false
    self.item.save!
    record_action(
      :delete_item,
      "item",
      self.item.id
    )

    return self.item
  end

  private
  attr_writer :item

  def check_authorization
    raise Errors::Unauthorized unless Current.user.is_authorized_to_delete_item?
  end

  def check_cards
    raise Errors::ItemHasCardsError if self.item.is_card? && self.item.has_cards? 
  end
end