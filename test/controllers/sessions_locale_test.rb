require "test_helper"

class SessionsLocaleTest < ActionDispatch::IntegrationTest
  test "failed sign in is russian even with english browser" do
    post user_session_url, params: { user: { email: "missing@example.com", password: "wrong" } }, headers: { "Accept-Language" => "en" }
    assert_response :unprocessable_entity
    assert_select ".dossier-flash-alert", text: "Неверный email или пароль."
  end

  test "sign out is russian" do
    sign_in users(:regular)
    delete destroy_user_session_url, headers: { "Accept-Language" => "en-US,en;q=0.9" }
    follow_redirect!
    assert_select ".dossier-flash", text: "Вы вышли."
  end
end
