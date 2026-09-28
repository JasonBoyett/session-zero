require "test_helper"

class AuthSessionTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  test "shows an unauthenticated session" do
    get "/api/v1/auth/session"

    assert_response :success

    body = JSON.parse(response.body)

    assert_equal false, body["authenticated"]
    assert body["csrf_token"].present?
  end

  test "shows an authenticated session" do
    sign_in users(:one)

    get "/api/v1/auth/session"

    assert_response :success

    body = JSON.parse(response.body)

    assert_equal true, body["authenticated"]
    assert body["csrf_token"].present?
    assert_equal users(:one).id, body["user_id"]
  end

  test "destroys an authenticated session" do
    sign_in users(:one)

    get "/api/v1/auth/session"
    csrf_token = JSON.parse(response.body).fetch("csrf_token")

    delete "/api/v1/auth/session", headers: { "X-CSRF-Token" => csrf_token }

    assert_response :success

    body = JSON.parse(response.body)

    assert_equal false, body["authenticated"]
    assert body["csrf_token"].present?
  end

  test "allows password login" do
    get "/api/v1/auth/session"
    csrf_token = JSON.parse(response.body).fetch("csrf_token")
    test_user = users(:one)
    post "/api/v1/auth/session",
      params: {
        email: test_user.email,
        password: "password"
      },
      headers: { "X-CSRF-Token" => csrf_token }

    assert_response :success
  end

  test "allows password login through login route" do
    get "/api/v1/auth/session"
    csrf_token = JSON.parse(response.body).fetch("csrf_token")
    test_user = users(:one)
    post "/api/v1/auth/login",
      params: {
        email: test_user.email,
        password: "password"
      },
      headers: { "X-CSRF-Token" => csrf_token }

    assert_response :success
  end

  test "rejects password login in production" do
    test_user = users(:one)
    previous = Rails.application.config.x.password_login_enabled
    Rails.application.config.x.password_login_enabled = false
    get "/api/v1/auth/session"

    csrf_token = JSON.parse(response.body).fetch("csrf_token")
    post "/api/v1/auth/session",
      params: {
        email: test_user.email,
        password: "password"
      },
      headers: { "X-CSRF-Token" => csrf_token }

    assert_response :not_found
  ensure
    Rails.application.config.x.password_login_enabled = previous
  end
end
