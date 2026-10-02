require "test_helper"

class UserGamesTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  test "requires an authenticated user" do
    get "/api/v1/auth/me/games"

    assert_response :unauthorized
  end

  test "returns gm identities and games where the current user is a player" do
    sign_in users(:one)

    get "/api/v1/auth/me/games"

    assert_response :success

    body = JSON.parse(response.body)

    assert_equal [ "games_as_player", "gm_identities" ], body.keys.sort

    gm_identities = body.fetch("gm_identities")
    games_as_player = body.fetch("games_as_player")

    assert_equal 2, gm_identities.length
    assert_equal 2, games_as_player.length

    gm_identity = gm_identities.find do |identity|
      identity["id"] == game_master_profiles(:one).id
    end

    assert_equal "Fixture Guide", gm_identity.fetch("display_name")
    assert_equal "https://example.com/gm-fixture-guide.png", gm_identity.fetch("profile_picture")
    assert_equal [ games(:one).id ], gm_identity.fetch("games").map { |game| game.fetch("id") }

    gm_game = gm_identity.fetch("games").first
    assert_equal "Fixture Game One", gm_game.fetch("name")
    assert_equal "Quest", gm_game.fetch("system")
    assert_equal "A fixture game for model and association tests.", gm_game.fetch("description")
    assert_equal 2, gm_game.fetch("player_count")
    assert_not gm_game.key?("gm_profile")
    assert_not gm_game.key?("player_profile")

    alt_gm_identity = gm_identities.find do |identity|
      identity["id"] == game_master_profiles(:one_alt).id
    end

    assert_equal "Fixture Chaos", alt_gm_identity.fetch("display_name")
    assert_equal [ games(:three).id ], alt_gm_identity.fetch("games").map { |game| game.fetch("id") }

    player_game = games_as_player.find do |game|
      game["player_profile"]["id"] == player_profiles(:one_in_two).id
    end
    assert_equal games(:two).id, player_game.fetch("id")
    assert_equal "Fixture Game Two", player_game.fetch("name")
    assert_equal "Fate", player_game.fetch("system")
    assert_equal "Another fixture game for model and association tests.", player_game.fetch("description")
    assert_equal 2, player_game.fetch("player_count")
    assert_equal({
      "id" => player_profiles(:one_in_two).id,
      "display_name" => "Fixture Guest",
      "profile_picture" => "https://example.com/fixture-guest.png"
    }, player_game.fetch("player_profile"))
    assert_equal({
      "id" => game_master_profiles(:two).id,
      "display_name" => "Fixture Oracle",
      "profile_picture" => "https://example.com/gm-fixture-oracle.png"
    }, player_game.fetch("gm_profile"))
  end

  test "uses snake case response keys before olive branch camelizes for the client" do
    sign_in users(:one)

    get "/api/v1/auth/me/games"

    assert_response :success

    body = JSON.parse(response.body)
    identity = body.fetch("gm_identities").first
    gm_game = identity.fetch("games").first
    player_game = body.fetch("games_as_player").first

    assert body.key?("gm_identities")
    assert body.key?("games_as_player")
    assert identity.key?("display_name")
    assert identity.key?("profile_picture")
    assert gm_game.key?("player_count")
    assert player_game.key?("player_profile")
    assert player_game.key?("gm_profile")

    assert_not body.key?("gmIdentities")
    assert_not body.key?("gamesAsPlayer")
    assert_not identity.key?("displayName")
    assert_not identity.key?("profilePicture")
    assert_not gm_game.key?("playerCount")
    assert_not player_game.key?("playerProfile")
    assert_not player_game.key?("gmProfile")
  end
end
