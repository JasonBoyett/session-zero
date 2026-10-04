require "test_helper"

class GameMasterProfileTest < ActiveSupport::TestCase
  test "profile attributes for owner include owner fields and exclude internal fields" do
    profile = game_master_profiles(:one)

    attributes = profile.profile_attributes_for(profile.user_id)

    assert_equal profile.id, attributes.fetch("id")
    assert_equal profile.name, attributes.fetch("name")
    assert attributes.key?("created_at")
    assert attributes.key?("last_used_at")
    assert_not attributes.key?("updated_at")
    assert_not attributes.key?("user_id")
  end

  test "profile attributes for non-owner exclude owner fields and internal fields" do
    profile = game_master_profiles(:one)

    attributes = profile.profile_attributes_for(users(:two).id)

    assert_equal profile.id, attributes.fetch("id")
    assert_equal profile.name, attributes.fetch("name")
    assert_not attributes.key?("created_at")
    assert_not attributes.key?("last_used_at")
    assert_not attributes.key?("updated_at")
    assert_not attributes.key?("user_id")
  end

  test "profile attributes include user id for public user profiles" do
    profile = game_master_profiles(:two)

    attributes = profile.profile_attributes_for(users(:one).id)

    assert_equal profile.user_id, attributes.fetch("user_id")
  end

  test "owner can update gm profile" do
    profile = game_master_profiles(:one)

    assert profile.update_allowed_for?(users(:one).id)
  end

  test "non-owner cannot update gm profile" do
    profile = game_master_profiles(:one)

    assert_not profile.update_allowed_for?(users(:two).id)
  end
end
