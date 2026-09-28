require "test_helper"
require "rack/mock"

class ApiJsonCasingTest < ActiveSupport::TestCase
  test "defaults to enabled outside test environments" do
    assert ApiJsonCasing.enabled?(env_value: nil, rails_env: "development")
    assert ApiJsonCasing.enabled?(env_value: nil, rails_env: "production")
  end

  test "defaults to disabled in test environment" do
    assert_not ApiJsonCasing.enabled?(env_value: nil, rails_env: "test")
  end

  test "camelizes api json responses when enabled" do
    app = lambda do |_env|
      body = JSON.generate(authenticated: true, csrf_token: "token", user_id: 1)

      [200, { "Content-Type" => "application/json" }, [body]]
    end

    response = Rack::MockRequest
      .new(OliveBranch::Middleware.new(app, **ApiJsonCasing.middleware_options))
      .get("/api/v1/auth/session")

    body = JSON.parse(response.body)

    assert_equal true, body["authenticated"]
    assert_equal "token", body["csrfToken"]
    assert_equal 1, body["userId"]
    assert_not body.key?("csrf_token")
    assert_not body.key?("user_id")
  end
end
