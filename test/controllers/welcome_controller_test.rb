require "test_helper"

class WelcomeControllerTest < ActionDispatch::IntegrationTest
  test "should get catalog as root" do
    get root_url
    assert_response :success
  end
end
