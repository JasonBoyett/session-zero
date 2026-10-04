require "test_helper"

class PlayerProfileTest < ActiveSupport::TestCase
  test "profile attributes for owner include owner fields and exclude internal fields" do
    profile = player_profiles(:one_in_two)

    attributes = profile.profile_attributes_for(profile.user_id)

    assert_equal profile.id, attributes.fetch("id")
    assert_equal profile.character_name, attributes.fetch("character_name")
    assert_equal profile.character_sheet_link, attributes.fetch("character_sheet_link")
    assert attributes.key?("created_at")
    assert attributes.key?("last_used_at")
    assert_not attributes.key?("updated_at")
    assert_not attributes.key?("game_id")
    assert_not attributes.key?("user_id")
  end

  test "profile attributes for non-owner exclude owner fields and internal fields" do
    profile = player_profiles(:one_in_two)

    attributes = profile.profile_attributes_for(users(:two).id)

    assert_equal profile.id, attributes.fetch("id")
    assert_equal profile.character_name, attributes.fetch("character_name")
    assert_equal profile.character_sheet_link, attributes.fetch("character_sheet_link")
    assert_not attributes.key?("created_at")
    assert_not attributes.key?("last_used_at")
    assert_not attributes.key?("updated_at")
    assert_not attributes.key?("game_id")
    assert_not attributes.key?("user_id")
  end

  test "profile attributes include user id for public user profiles" do
    profile = player_profiles(:two)

    attributes = profile.profile_attributes_for(users(:one).id)

    assert_equal profile.user_id, attributes.fetch("user_id")
  end

  test "owner can update player-owned profile attributes" do
    profile = player_profiles(:one_pending_four)

    assert profile.update_allowed_for?(users(:one).id)
  end

  test "unrelated users cannot update player profiles" do
    unrelated_user = User.create!(
      name: "Unrelated User",
      email: "unrelated@example.com",
      password: "password"
    )

    assert_not player_profiles(:one_pending_four).update_allowed_for?(
      unrelated_user.id
    )
  end
end
