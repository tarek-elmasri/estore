# Preview all emails at http://localhost:3000/rails/mailers/forget_passwords_mailer
class ForgetPasswordsMailerPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/forget_passwords_mailer/send_reset_mail
  def send_reset_mail
    ForgetPasswordsMailer.send_reset_mail
  end

end
