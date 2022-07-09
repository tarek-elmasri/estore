class Interfaces::Cards::CardCreation
  include StaffTracker::Recorder

  attr_reader :card

  def initialize params
    self.card = Card.new(params)
  end

  def create!
    check_authorization
    Card.transaction do
      card.save!
      Item::ItemStocker.new(card.item)
                      .add_to_stock!(1)
    end

    record(
      :create,
      "card",
      self.card.id
    )

    return self.card
  end

  private
  
  attr_writer :card
  def check_authorization
    raise Errors::Unauthorized unless Current.user.is_authorized_to_create_card?
  end

end