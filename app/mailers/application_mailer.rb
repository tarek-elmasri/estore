class ApplicationMailer < ActionMailer::Base
  default from: Rails.application.credentials.dig(:gmail_account_settings, :username)
  layout 'mailer'
end
