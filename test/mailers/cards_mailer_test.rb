require "test_helper"

class CardsMailerTest < ActionMailer::TestCase
  test "deliver_cards" do
    mail = CardsMailer.deliver_cards
    assert_equal "Deliver cards", mail.subject
    assert_equal ["to@example.org"], mail.to
    assert_equal ["from@example.com"], mail.from
    assert_match "Hi", mail.body.encoded
  end

end
