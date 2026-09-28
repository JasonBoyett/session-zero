require "test_helper"

class UserIdentityTest < ActiveSupport::TestCase
  test "User Identity should belong to a user" do
    identity = user_identities(:one)
    assert_equal users(:one), identity.user
  end

  test "User Identity should require a user" do
    identity = UserIdentity.new(
      provider: "discord",
      uid: "hi"
    )

    assert_not identity.valid?
    assert_includes identity.errors[:user], "must exist"
  end

  test "User Identity should require a provider" do
    identity = UserIdentity.new(
        user: users(:one),
        uid: "123"
      )

    assert_not identity.valid?
    assert_includes identity.errors[:provider], "can't be blank"
  end

  test "User Identity should require a uid" do
    identity = UserIdentity.new(
        user: users(:one),
        provider: "discord"
      )

    assert_not identity.valid?
    assert_includes identity.errors[:uid], "can't be blank"
  end

  test "User Identities must have unique provider uid pairs" do
    existing_identity = user_identities(:one)
    duplicate = UserIdentity.new(
        user: users(:two),
        provider: existing_identity.provider,
        uid: existing_identity.uid
      )

    assert_not duplicate.valid?
    assert_includes duplicate.errors[:uid], "has already been taken"
  end

  test "User Identities may have duplicate uids for different providers" do
    existing_identity = user_identities(:one)
    duplicate = UserIdentity.new(
        user: users(:two),
        provider: "other",
        uid: existing_identity.uid
      )

    assert duplicate.valid?
  end

  test "Destroying a user should destroy all user identities" do
    user = User.create!(
      email: "test@example.com",
      password: "password",
      password_confirmation: "password"
    )

    first_identity = UserIdentity.create!(
      user: user,
      provider: "provider",
      uid: "123"
    )
    second_identity = UserIdentity.create!(
      user: user,
      provider: "other",
      uid: "123"
    )

    assert_difference "UserIdentity.count", -2 do
      user.destroy!
    end

    assert_not UserIdentity.exists?(first_identity.id)
    assert_not UserIdentity.exists?(second_identity.id)
  end
end
