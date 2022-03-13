require "test_helper"

class SessionsControllerTest < ActionDispatch::IntegrationTest
  test "should get me" do
    get sessions_me_url
    assert_response :success
  end
end
