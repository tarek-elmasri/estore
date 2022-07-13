class Api::V1::Dashboard::CardsController < Api::V1::Dashboard::Base
  include Scopes::Dashboard::CardsScopes

  before_action :set_card, except: [:index , :create]
  before_action :authorize_show, only: [:index]

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
    respond(
      serialize_resource(
        card,
        serializer: Dashboard::CardSerializer
      ).to_json
    )
  end

  def update
    updated_card = Card::CardUpdate.new(@card).update!(cards_params)
    respond(
      serialize_resource(
        updated_card,
        serializer: Dashboard::CardSerializer
      ).to_json
    )
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

  def authorize_show
    raise Errors::Unauthorized unless Current.user.is_authorized_to_show_cards?
  end

end