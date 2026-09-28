require "test_helper"

class IdentityServiceTest < ActiveSupport::TestCase
  test "existing identity returns user" do
    user = users(:one)
    auth = OmniAuth::AuthHash.new(

      provider: "provider",
      uid: "hi"
    )
    UserIdentity
      .create!(
        provider: auth[:provider],
        uid: auth[:uid],
        user: user
      )
    identity_user = IdentityService.authenticate(auth)

    assert_equal user, identity_user
  end

  test "verified provider email links to user" do
    user = users(:one)
    auth = OmniAuth::AuthHash.new(
      provider: "provider",
      uid: "hi",
      info: {
        email: user.email
      }
    )
    identity_user = IdentityService.authenticate(auth)

    assert_equal user, identity_user
  end

  test "unlinked identity creates a new user" do
    auth = OmniAuth::AuthHash.new(
      provider: "discord",
      uid: "new",
      info: {
        email: "new@not-yet-linked.com"
      }
    )

    IdentityService.authenticate(auth)
    assert User.find_by(email: auth.info.email)
  end

  test "identity without email creates a new user" do
    existing_email_less_user = users(:with_null_email)

    auth = OmniAuth::AuthHash.new(
      provider: "discord",
      uid: "discord-without-email",
      info: {
        name: "Discord User",
        email: nil,
        image: "https://example.com/avatar.png"
      }
    )

    authenticated_user = nil

    assert_difference "User.count", 1 do
      authenticated_user = IdentityService.authenticate(auth)
    end

    assert_not_equal existing_email_less_user, authenticated_user
    assert_nil authenticated_user.email
  end

  test "should not allow invalide providers" do
    auth = OmniAuth::AuthHash.new(
      provider: "invalid",
      uid: "new",
    )
    assert_raises(RuntimeError) do
      IdentityService.authenticate(auth)
    end
  end

  test "allows discord as a provider" do
    auth = OmniAuth::AuthHash.new(
      provider: "discord",
      uid: "new",
      info: {
        email: "new@not-yet-linked.com"
      }
    )

    IdentityService.authenticate(auth)
    assert User.find_by(email: auth.info.email)
  end
end
