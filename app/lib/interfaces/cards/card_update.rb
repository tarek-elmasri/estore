class Interfaces::Cards::CardUpdate
  include StaffTracker::Recorder

  attr_reader :card

  def initialize card
    self.card = card
  end

  def update! params
    check_authorization
    self.card.update!(params)

    record_action(
      :update,
      "card",
      self.card.id
    )

    return self.card
  end

  private
  attr_writer :card
  def check_authorization
    raise Errors::Unauthorized unless Current.user.is_authorized_to_update_card?
  end

end