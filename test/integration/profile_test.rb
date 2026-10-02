require "test_helper"

class ProfileTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  test "requires an authenticated user for profile routes" do
    get "/api/v1/profile/user/#{users(:one).id}"

    assert_response :unauthorized
  end

  test "returns a user profile" do
    sign_in users(:one)

    get "/api/v1/profile/user/#{users(:one).id}"

    assert_response :success

    body = JSON.parse(response.body)

    assert_equal users(:one).id, body.fetch("id")
    assert_equal "User One", body.fetch("name")
    assert_nil body.fetch("profile_picture")
    assert_equal "one@example.com", body.fetch("email")
    assert body.key?("created_at")
    assert body.key?("updated_at")
    assert_not body.key?("encrypted_password")
    assert_not body.key?("reset_password_token")
  end

  test "returns only public user profile fields to non-owners" do
    sign_in users(:two)

    get "/api/v1/profile/user/#{users(:one).id}"

    assert_response :success

    body = JSON.parse(response.body)

    assert_equal users(:one).id, body.fetch("id")
    assert_equal "User One", body.fetch("name")
    assert_nil body.fetch("profile_picture")
    assert_not body.key?("email")
    assert_not body.key?("created_at")
    assert_not body.key?("updated_at")
    assert_not body.key?("encrypted_password")
  end

  test "returns a gm profile" do
    sign_in users(:one)

    get "/api/v1/profile/gm/#{game_master_profiles(:one).id}"

    assert_response :success

    body = JSON.parse(response.body)

    assert_equal game_master_profiles(:one).id, body.fetch("id")
    assert_equal "Fixture Guide", body.fetch("name")
    assert_equal "https://example.com/gm-fixture-guide.png", body.fetch("profile_picture")
    assert_equal "A steady GM profile owned by User One.", body.fetch("bio")
    assert_equal [ "Quest" ], body.fetch("systems")
    assert_equal false, body.fetch("is_user_public")
    assert body.key?("created_at")
    assert body.key?("last_used_at")
    assert_not body.key?("updated_at")
    assert_not body.key?("user_id")
  end

  test "returns only public gm profile fields to non-owners" do
    sign_in users(:two)

    get "/api/v1/profile/gm/#{game_master_profiles(:one).id}"

    assert_response :success

    body = JSON.parse(response.body)

    assert_equal game_master_profiles(:one).id, body.fetch("id")
    assert_equal "Fixture Guide", body.fetch("name")
    assert_equal "https://example.com/gm-fixture-guide.png", body.fetch("profile_picture")
    assert_equal "A steady GM profile owned by User One.", body.fetch("bio")
    assert_equal [ "Quest" ], body.fetch("systems")
    assert_not body.key?("created_at")
    assert_not body.key?("last_used_at")
    assert_not body.key?("updated_at")
    assert_not body.key?("user_id")
  end

  test "returns gm user id when the profile makes its user public" do
    sign_in users(:one)

    get "/api/v1/profile/gm/#{game_master_profiles(:two).id}"

    assert_response :success

    body = JSON.parse(response.body)

    assert_equal users(:two).id, body.fetch("user_id")
  end

  test "returns a player profile" do
    sign_in users(:one)

    get "/api/v1/profile/player/#{player_profiles(:one_in_two).id}"

    assert_response :success

    body = JSON.parse(response.body)

    assert_equal player_profiles(:one_in_two).id, body.fetch("id")
    assert_equal "Fixture Guest", body.fetch("character_name")
    assert_equal "https://example.com/fixture-guest.png", body.fetch("character_image")
    assert_equal "User One playing at User Two's table.", body.fetch("character_description")
    assert_equal "https://example.com/sheets/fixture-guest", body.fetch("character_sheet_link")
    assert_equal true, body.fetch("is_accepted")
    assert_equal false, body.fetch("is_user_public")
    assert body.key?("created_at")
    assert body.key?("last_used_at")
    assert_not body.key?("updated_at")
    assert_not body.key?("game_id")
    assert_not body.key?("user_id")
  end

  test "returns only public player profile fields to non-owners" do
    sign_in users(:two)

    get "/api/v1/profile/player/#{player_profiles(:one_in_two).id}"

    assert_response :success

    body = JSON.parse(response.body)

    assert_equal player_profiles(:one_in_two).id, body.fetch("id")
    assert_equal "Fixture Guest", body.fetch("character_name")
    assert_equal "https://example.com/fixture-guest.png", body.fetch("character_image")
    assert_equal "User One playing at User Two's table.", body.fetch("character_description")
    assert_equal true, body.fetch("is_accepted")
    assert_equal "https://example.com/sheets/fixture-guest", body.fetch("character_sheet_link")
    assert_not body.key?("created_at")
    assert_not body.key?("last_used_at")
    assert_not body.key?("updated_at")
    assert_not body.key?("game_id")
    assert_not body.key?("user_id")
  end

  test "returns player user id when the profile makes its user public" do
    sign_in users(:one)

    get "/api/v1/profile/player/#{player_profiles(:two).id}"

    assert_response :success

    body = JSON.parse(response.body)

    assert_equal users(:two).id, body.fetch("user_id")
  end

  test "returns not found for a missing profile" do
    sign_in users(:one)

    get "/api/v1/profile/gm/0"

    assert_response :not_found
  end
end
