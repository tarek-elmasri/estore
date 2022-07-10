require "test_helper"

class ForgetPasswordsMailerTest < ActionMailer::TestCase
  test "send_reset_mail" do
    mail = ForgetPasswordsMailer.send_reset_mail
    assert_equal "Send reset mail", mail.subject
    assert_equal ["to@example.org"], mail.to
    assert_equal ["from@example.com"], mail.from
    assert_match "Hi", mail.body.encoded
  end

end
