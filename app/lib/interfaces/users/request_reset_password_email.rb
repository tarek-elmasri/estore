class Interfaces::Users::RequestResetPasswordEmail

  attr_reader :email
  attr_reader :reset_link

  def initialize(email , reset_link)
    self.email = email
    self.reset_link = reset_link
  end

  def create!
    user= User.find_by_email(email)
    if user
      raise Errors::BlockedUser if user.blocked?
      
      send_mail(user.forget_password_token)
      devalidating_job()
    end
  end

  private
  attr_writer :email
  attr_writer :reset_link

  def send_mail token
    ForgetPasswordsMailer.send_reset_mail(email , token , reset_link)
                          .deliver_later
  end

  def devalidating_job
    DevalidatePasswordTokensJob
    .set(wait: 30.minutes)
    .perform_later(user.id, user.forget_password_token)
  end
end