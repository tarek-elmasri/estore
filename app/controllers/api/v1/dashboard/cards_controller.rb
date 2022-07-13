class Api::V1::Dashboard::CardsController < Api::V1::Dashboard::Base
  include Scopes::Dashboard::CardsScopes

  before_action :set_card, except: [:index , :create]
  
  apply_controller_scopes only: [:index]

  def index
    cards= apply_scopes(Card.available.where(item_id: params.require(:item_id)).page(1))
    respond({
      cards: serialize_resource(
                cards,
                each_serializer: Dashboard::CardSerializer
              ),
      pagination_details: pagination_details(cards)
    })
  end

  def create
    card = Card::CardCreation.new(cards_params).create!
    respond(card)
  end

  def update
    updated_card = Card::CardUpdate.new(@card).update!(cards_params)
    respond(updated_card)
  end

  def delete
    deleted_card = Card::CardDestroy.new(@card).destroy!
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