class ForgetPasswordsMailer < ApplicationMailer
  #append_view_path "app/views/hind_mailer"
  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.forget_passwords_mailer.send_reset_mail.subject
  #
  def send_reset_mail(email , token , reset_link)
    @greeting = "Hi"

    mail to: email, subject: 'Reset Password'
  end

  def send_successfull_reset_mail(name,email)

  end
end
