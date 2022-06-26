# Preview all emails at http://localhost:3000/rails/mailers/cards_mailer
class CardsMailerPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/cards_mailer/deliver_cards
  def deliver_cards
    CardsMailer.deliver_cards('f7027b17-1ddc-4bde-acb2-14ba03f28128')
  end

end
