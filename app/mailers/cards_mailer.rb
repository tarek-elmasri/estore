class CardsMailer < ApplicationMailer

  after_action :set_delivery_status
  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.cards_mailer.deliver_cards.subject
  #
  def deliver_cards(order_id)
    @order = Order.include_user
                  .include_order_items
                  .include_order_cards
                  .find(order_id)

    
    mail to: @order.user.email, subject: 'Your Codes Are Here!'
  end

  private
  def set_delivery_status
    
  end
end
