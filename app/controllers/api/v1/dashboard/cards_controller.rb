class Api::V1::Dashboard::CardsController < Api::V1::Dashboard::Base

  before_action :set_card, except: [:index , :create]

  def index
    cards= Card.available.where(item_id: params.require(:item_id))
    respond(cards)
  end

  def create
    card=Card.new(cards_params)
    card.save!
    respond(card)
  end

  def update
    @card.update!(code: params.require(:code))
    respond(@card)
  end

  def delete
    @card.destroy!
    respond_ok
  end

  private
  def cards_params
    params.require(:card).permit(
      :item_id,
      :code
    )
  end

  def set_card
    @card= Card.available.find(params.require(:id))
  end

end