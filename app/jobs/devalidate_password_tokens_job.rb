class DevalidatePasswordTokensJob < ApplicationJob
  queue_as :default

  def perform(user_id, token)
    user=User.find_by(id: user_id)
    return unless user.forget_password_token == token

    user.regenerate_forget_password_token
  end
end
