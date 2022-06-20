class Api::V1::Dashboard::CardsController < Api::V1::Dashboard::Base

  before_action :set_card, except: [:index , :create]

  def index
    cards= Card.available.where(item_id: params[:item_id])
    respond(cards)
  end

  def create
    card=Card.new(cards_params)
    card.save!
    respond(card)
  end

  def update
    @card.update!(code: params[:code])
    respond(@card)
  end

  def destroy
    @card.destroy!
    respond(@card)
  end

  private
  def cards_params
    params.require(:card).permit(
      :item_id,
      :code
    )
  end

  def set_card
    @card= Card.available.find(params[:id])
  end

end