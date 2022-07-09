class CardsMailer < ApplicationMailer

  #after_action :set_delivery_status
  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.cards_mailer.deliver_cards.subject
  #
  def deliver_cards(order_id)
    @order = Order.include_user
                  .include_order_items
                  .find(order_id)

    @user = @order.user
    @order_items = @order.order_items

    return unless @order.has_cards_attached?

    mail to: @user.email, subject: 'Your Codes Are Here!'
  end

  private
  def set_delivery_status
    OrderItem::CardsMailerUpdateDeliveryStatus.new(@order_items).update_all
  end
end
