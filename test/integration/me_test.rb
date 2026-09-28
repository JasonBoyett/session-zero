require "test_helper"

class MeTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  test "shows the current authenticated user" do
    target_user = users(:one)
    sign_in users(:one)
    get "/api/v1/auth/me"

    assert_response :success

    body = JSON.parse(response.body)

    expected_keys = User.user_visible_attributes

    expected_keys.each do |key|
      expected_value = target_user.public_send(key).as_json

      if expected_value.nil?
        assert_nil body[key]
      else
        assert_equal expected_value, body[key]
      end
    end

    assert_equal expected_keys.sort, body.keys.sort
  end

  test "edits the current authenticated user" do
    profile_picture = "https://example.com/profile_picture.png"

    sign_in users(:one)
    get "/api/v1/auth/session"
    csrf_token = JSON.parse(response.body).fetch("csrf_token")

    patch "/api/v1/auth/me", params: {
      profile_picture: profile_picture
    },
      headers: { "X-CSRF-Token" => csrf_token }

    assert_response :success

    target_user = User.find(users(:one).id)
    assert_equal profile_picture, target_user.profile_picture
  end
end
