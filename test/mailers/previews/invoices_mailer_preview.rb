# Preview all emails at http://localhost:3000/rails/mailers/invoices_mailer
class InvoicesMailerPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/invoices_mailer/send_invoice
  def send_invoice
    InvoicesMailer.send_invoice(Order.first)
  end

end
