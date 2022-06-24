class InvoicesMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.invoices_mailer.send_invoice.subject
  #
  def send_invoice
    @greeting = "Hi"

    mail to: "tito4g@gmail.com"
  end
end
