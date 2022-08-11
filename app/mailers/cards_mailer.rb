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
    #raise StandardError.new

    #return unless @order.has_cards_attached?

    mail to: @user.email, subject: 'Your Codes Are Here!'

    set_delivery_status('delivered')
  rescue
    set_delivery_status('failed')
  end
    
  private
  def set_delivery_status status
    OrderItem::CardsMailerUpdateDeliveryStatus.new(@order_items).update_all(status)
  end

end
