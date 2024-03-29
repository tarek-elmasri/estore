class Interfaces::Cards::CardDestroy
  include StaffTracker::Recorder

  attr_reader :card

  def initialize card
    self.card = card
  end

  def destroy!
    check_authorization
    
    self.card.with_lock do
      raise StandardError.new('card attached to order') unless self.card.active
      self.card.destroy!
      Item::ItemStocker.new(self.card.item)
                        .remove_stock!(1)
    end

    record_action(
      :delete,
      "card",
      self.card.id
    )

    return self.card
  end

  private
  attr_writer :card
  def check_authorization
    raise Errors::Unauthorized unless Current.user.is_authorized_to_delete_card?
  end
end