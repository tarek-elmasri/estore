class Interfaces::Users::ResetPassword

  attr_reader :user

  def initialize user
    self.user=user
  end

  def set_new_password new_pass
    User.transaction do
      user.password = new_pass
      user.should_validate_password = true
      user.forget_password_token = nil
      user.reset_refresh_token
      user.save!
      kill_current_session
      create_new_session
    end

    send_successfull_reset_mail()
    return self.user
  end

  private
  attr_writer :user

  def kill_current_session
    Session.kill_by_user_id(user.id)
  end

  def create_new_session
    Session.create_or_update(user.id)
  end

  def send_successfull_reset_mail
    ForgetPasswordsMailer
        .send_successfull_reset_mail(user.first_name , user.email)
        .deliver_later
  end
end