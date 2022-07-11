class InvoicesMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.invoices_mailer.send_invoice.subject
  #
  def send_invoice(order_id)
    @order=Order.find(order_id)
    @user= @order.user
    mail to: @user.email, subject: 'Order Confirmation' do |format|
    end
  end
end
