require "test_helper"

class OauthCallbackTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @previous_client_url = Rails.application.config.x.client_url
    @previous_test_mode = OmniAuth.config.test_mode
    @previous_mock_auth = OmniAuth.config.mock_auth.dup

    Rails.application.config.x.client_url = "http://client.example"
    OmniAuth.config.test_mode = true
  end

  teardown do
    Rails.application.config.x.client_url = @previous_client_url
    OmniAuth.config.test_mode = @previous_test_mode
    OmniAuth.config.mock_auth = @previous_mock_auth
  end

  test "callback signs in and redirects to the client redirect path" do
    user = users(:one)
    auth = OmniAuth::AuthHash.new(
      provider: "discord",
      uid: user_identities(:one).uid,
      info: {
        email: user.email
      }
    )

    OmniAuth.config.mock_auth[:discord] = auth

    get "/api/v1/auth/oauth/discord/callback",
      params: { redirect: "/games" }

    assert_redirected_to "http://client.example/games"

    get "/api/v1/auth/session"

    body = JSON.parse(response.body)
    assert_equal true, body["authenticated"]
    assert_equal user.id, body["user_id"]
  end

  test "request phase preserves the redirect path through the oauth callback" do
    user = users(:one)
    auth = OmniAuth::AuthHash.new(
      provider: "discord",
      uid: user_identities(:one).uid,
      info: {
        email: user.email
      }
    )
    OmniAuth.config.mock_auth[:discord] = auth

    get "/api/v1/auth/session"
    csrf_token = JSON.parse(response.body).fetch("csrf_token")

    post "/api/v1/auth/oauth/discord",
      params: { redirect: "/games" },
      headers: { "X-CSRF-Token" => csrf_token }

    follow_redirect!

    assert_redirected_to "http://client.example/games"
  end

  test "request phase accepts browser form authenticity token" do
    auth = OmniAuth::AuthHash.new(
      provider: "discord",
      uid: user_identities(:one).uid,
      info: {
        email: users(:one).email
      }
    )
    OmniAuth.config.mock_auth[:discord] = auth

    get "/api/v1/auth/session"
    csrf_token = JSON.parse(response.body).fetch("csrf_token")

    post "/api/v1/auth/oauth/discord",
      params: {
        authenticity_token: csrf_token,
        redirect: "/games"
      }

    follow_redirect!

    assert_redirected_to "http://client.example/games"
  end

  test "callback falls back to the auth callback path" do
    auth = OmniAuth::AuthHash.new(
      provider: "discord",
      uid: user_identities(:one).uid,
      info: {
        email: users(:one).email
      }
    )

    OmniAuth.config.mock_auth[:discord] = auth

    get "/api/v1/auth/oauth/discord/callback"

    assert_redirected_to "http://client.example/auth/callback"
  end

  test "callback keeps redirect within the configured client url" do
    auth = OmniAuth::AuthHash.new(
      provider: "discord",
      uid: user_identities(:one).uid,
      info: {
        email: users(:one).email
      }
    )

    OmniAuth.config.mock_auth[:discord] = auth

    get "/api/v1/auth/oauth/discord/callback",
      params: { redirect: "//evil.example/path" }

    assert_redirected_to "http://client.example/evil.example/path"
  end

  test "callback rejects unsupported providers from the route" do
    auth = OmniAuth::AuthHash.new(
      provider: "discord",
      uid: user_identities(:one).uid,
      info: {
        email: users(:one).email
      }
    )

    OmniAuth.config.mock_auth[:discord] = auth

    get "/api/v1/auth/oauth/google/callback"

    assert_response :not_found
  end

  test "failure redirects to the client redirect path with oauth error" do
    get "/api/v1/auth/oauth/failure",
      params: { redirect: "/login", message: "invalid_credentials" }

    assert_redirected_to "http://client.example/login?error=invalid_credentials"
  end

  test "failure can use omniauth origin as the client redirect path" do
    get "/api/v1/auth/oauth/failure",
      params: { origin: "/login", message: "csrf_detected" }

    assert_redirected_to "http://client.example/login?error=csrf_detected"
  end

  test "passthru rejects unsupported provider requests not handled by omniauth" do
    get "/api/v1/auth/session"
    csrf_token = JSON.parse(response.body).fetch("csrf_token")

    post "/api/v1/auth/oauth/google",
      headers: { "X-CSRF-Token" => csrf_token }

    assert_response :not_found
  end
end
