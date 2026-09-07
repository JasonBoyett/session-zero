class IdentityService

  def self.authenticate(auth)
    identity = UserIdentity.find_by(
      provider: auth.provider,
      uid: auth.uid
    )

    return identity.user if identity

    user = User.find_by(email: auth.info.email)

    if user
      user.user_identities.create!(
        provider: auth.provider,
        uid: auth.uid
      )

      return user
    end

    new_user = case auth.provider
    when "discord"
      DiscordIdentityParser.parse(auth)
    when "google"
      # TODO: set up google oauth
      # GoogleIdentityParser.parse(auth)
    else
      raise "Unsupported provider: #{auth.provider}"
    end

    User.transaction do
      user = User.create! new_user.user
      user.user_identities.create! new_user.identity

      return user
    end
  end
end
