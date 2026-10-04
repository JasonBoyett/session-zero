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
    assert_equal true, user_info.fetch("can_edit")
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
    assert_equal false, user_info.fetch("can_edit")
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

  test "owner can update their user profile" do
    sign_in users(:one)

    patch "/api/v1/profile/user/#{users(:one).id}", params: {
      name: "Updated User One",
      profile_picture: "https://example.com/updated-user-one.png",
      email: "should-not-change@example.com"
    }, headers: csrf_headers

    assert_response :success
    assert_equal({ "error" => nil }, JSON.parse(response.body))

    users(:one).reload
    assert_equal "Updated User One", users(:one).name
    assert_equal "https://example.com/updated-user-one.png", users(:one).profile_picture
    assert_equal "one@example.com", users(:one).email
  end

  test "non-owner cannot update a user profile" do
    sign_in users(:two)

    patch "/api/v1/profile/user/#{users(:one).id}", params: {
      name: "Unauthorized Update"
    }, headers: csrf_headers

    assert_response :forbidden
    assert_equal({ "error" => "not_authorized" }, JSON.parse(response.body))
    assert_equal "User One", users(:one).reload.name
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
    assert_equal true, body.fetch("can_edit")
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
    assert_equal false, body.fetch("can_edit")
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

  test "owner can update a gm profile" do
    sign_in users(:one)

    patch "/api/v1/profile/gm/#{game_master_profiles(:one).id}", params: {
      name: "Updated Fixture Guide",
      bio: "Updated bio.",
      profile_picture: "https://example.com/updated-gm.png",
      systems: [ "Quest", "Fate" ],
      is_user_public: true,
      user_id: users(:two).id
    }, headers: csrf_headers

    assert_response :success
    assert_equal({ "error" => nil }, JSON.parse(response.body))

    game_master_profiles(:one).reload
    assert_equal "Updated Fixture Guide", game_master_profiles(:one).name
    assert_equal "Updated bio.", game_master_profiles(:one).bio
    assert_equal "https://example.com/updated-gm.png", game_master_profiles(:one).profile_picture
    assert_equal [ "Quest", "Fate" ], game_master_profiles(:one).systems
    assert_equal true, game_master_profiles(:one).is_user_public
    assert_equal users(:one).id, game_master_profiles(:one).user_id
  end

  test "non-owner cannot update a gm profile" do
    sign_in users(:two)

    patch "/api/v1/profile/gm/#{game_master_profiles(:one).id}", params: {
      name: "Unauthorized GM Update"
    }, headers: csrf_headers

    assert_response :forbidden
    assert_equal({ "error" => "not_authorized" }, JSON.parse(response.body))
    assert_equal "Fixture Guide", game_master_profiles(:one).reload.name
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
    assert_equal true, body.fetch("can_edit")
    assert_equal false, body.fetch("can_accept")
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
    assert_equal false, body.fetch("can_edit")
    assert_equal true, body.fetch("can_accept")
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

  test "player profile owner can update player-owned fields" do
    sign_in users(:one)

    patch "/api/v1/profile/player/#{player_profiles(:one_pending_four).id}", params: {
      character_name: "Updated Pending",
      character_description: "Updated pending description.",
      character_image: "https://example.com/updated-pending.png",
      character_sheet_link: "https://example.com/sheets/updated-pending",
      is_user_public: true,
      game_id: games(:one).id
    }, headers: csrf_headers

    assert_response :success
    assert_equal({ "error" => nil }, JSON.parse(response.body))

    player_profiles(:one_pending_four).reload
    assert_equal "Updated Pending", player_profiles(:one_pending_four).character_name
    assert_equal "Updated pending description.", player_profiles(:one_pending_four).character_description
    assert_equal "https://example.com/updated-pending.png", player_profiles(:one_pending_four).character_image
    assert_equal "https://example.com/sheets/updated-pending", player_profiles(:one_pending_four).character_sheet_link
    assert_equal true, player_profiles(:one_pending_four).is_user_public
    assert_equal games(:four).id, player_profiles(:one_pending_four).game_id
  end

  test "player profile update does not change acceptance" do
    sign_in users(:one)

    patch "/api/v1/profile/player/#{player_profiles(:one_pending_four).id}", params: {
      is_accepted: true
    }, headers: csrf_headers

    assert_response :success
    assert_equal({ "error" => nil }, JSON.parse(response.body))
    assert_equal false, player_profiles(:one_pending_four).reload.is_accepted
  end

  test "gm cannot update player-owned fields on a player profile" do
    sign_in users(:two)

    patch "/api/v1/profile/player/#{player_profiles(:one_pending_four).id}", params: {
      character_name: "GM Rename"
    }, headers: csrf_headers

    assert_response :forbidden
    assert_equal({ "error" => "not_authorized" }, JSON.parse(response.body))
    assert_equal "Fixture Pending", player_profiles(:one_pending_four).reload.character_name
  end

  test "returns not found for a missing profile" do
    sign_in users(:one)

    get "/api/v1/profile/gm/0"

    assert_response :not_found
  end

  private

  def csrf_headers
    get "/api/v1/auth/session"

    {
      "X-CSRF-Token" => JSON.parse(response.body).fetch("csrf_token")
    }
  end
end
