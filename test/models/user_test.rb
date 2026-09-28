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
end
