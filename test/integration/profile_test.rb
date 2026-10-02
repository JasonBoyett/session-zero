require "test_helper"

class ProfileTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  test "requires an authenticated user for profile routes" do
    get "/api/v1/profile/user/#{users(:one).id}"

    assert_response :unauthorized
  end

  test "returns a user profile page payload" do
    sign_in users(:one)

    get "/api/v1/profile/user/#{users(:one).id}"

    assert_response :success

    body = JSON.parse(response.body)
    user_info = body.fetch("user_info")
    gm_profiles = body.fetch("gm_profiles")
    player_profiles = body.fetch("player_profiles")

    assert_equal users(:one).id, user_info.fetch("id")
    assert_equal "User One", user_info.fetch("name")
    assert_nil user_info.fetch("profile_picture")
    assert_equal "one@example.com", user_info.fetch("email")
    assert user_info.key?("created_at")
    assert user_info.key?("updated_at")
    assert_not user_info.key?("encrypted_password")
    assert_not user_info.key?("reset_password_token")

    assert_equal [
      game_master_profiles(:one).id,
      game_master_profiles(:one_alt).id
    ].sort, gm_profiles.map { |profile| profile.fetch("id") }.sort
    assert_equal [
      player_profiles(:one_in_two).id,
      player_profiles(:one_pending_four).id
    ].sort, player_profiles.map { |profile| profile.fetch("id") }.sort
  end

  test "returns only public user profile page fields to non-owners" do
    sign_in users(:two)

    get "/api/v1/profile/user/#{users(:one).id}"

    assert_response :success

    body = JSON.parse(response.body)
    user_info = body.fetch("user_info")

    assert_equal users(:one).id, user_info.fetch("id")
    assert_equal "User One", user_info.fetch("name")
    assert_nil user_info.fetch("profile_picture")
    assert_not user_info.key?("email")
    assert_not user_info.key?("created_at")
    assert_not user_info.key?("updated_at")
    assert_not user_info.key?("encrypted_password")
    assert_empty body.fetch("gm_profiles")
    assert_empty body.fetch("player_profiles")
  end

  test "returns public linked profiles on user profile pages to non-owners" do
    sign_in users(:one)

    get "/api/v1/profile/user/#{users(:two).id}"

    assert_response :success

    body = JSON.parse(response.body)

    assert_equal [ game_master_profiles(:two).id ], body.fetch("gm_profiles").map { |profile| profile.fetch("id") }
    assert_equal [ player_profiles(:two).id ], body.fetch("player_profiles").map { |profile| profile.fetch("id") }
    assert body.fetch("gm_profiles").first.key?("user_id")
    assert body.fetch("player_profiles").first.key?("user_id")
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
