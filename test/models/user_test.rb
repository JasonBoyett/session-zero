require "test_helper"

class UserTest < ActiveSupport::TestCase
  test "should be invalid without an email if there are no identities" do
    user = users(:with_null_email)
    assert_not user.valid?
  end

  test "should be valid with no email if there are identities" do
    user = users(:with_null_email)
    user.user_identities.build provider: "discord", uid: "1234"

    assert user.valid?
  end

  test "should be invalid if the profile picture is not a valid image URL" do
    user = users(:one)
    user.profile_picture = "not a valid image URL"
    assert_not user.valid?
  end

  test "should be valid if there is no profile picture" do
    user = users(:one)
    user.profile_picture = nil
    assert user.valid?
  end

  test "profile attributes for owner include owner fields and exclude auth fields" do
    user = users(:one)

    attributes = user.profile_attributes_for(user.id)

    assert_equal user.id, attributes.fetch("id")
    assert_equal user.email, attributes.fetch("email")
    assert attributes.key?("created_at")
    assert attributes.key?("updated_at")
    assert_not attributes.key?("encrypted_password")
    assert_not attributes.key?("remember_created_at")
    assert_not attributes.key?("reset_password_sent_at")
    assert_not attributes.key?("reset_password_token")
  end

  test "profile attributes for non-owner exclude owner fields and auth fields" do
    user = users(:one)

    attributes = user.profile_attributes_for(users(:two).id)

    assert_equal user.id, attributes.fetch("id")
    assert_not attributes.key?("email")
    assert_not attributes.key?("created_at")
    assert_not attributes.key?("updated_at")
    assert_not attributes.key?("encrypted_password")
    assert_not attributes.key?("remember_created_at")
    assert_not attributes.key?("reset_password_sent_at")
    assert_not attributes.key?("reset_password_token")
  end

  test "owner can update user profile" do
    user = users(:one)

    assert user.update_allowed_for?(users(:one).id)
  end

  test "non-owner cannot update user profile" do
    user = users(:one)

    assert_not user.update_allowed_for?(users(:two).id)
  end
end
