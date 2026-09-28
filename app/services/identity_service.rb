class IdentityService
  PROVIDERS = {
    "discord" => DiscordIdentityParser
  }.tap do |providers|
    providers["provider"] = DiscordIdentityParser if Rails.env.test?
  end.freeze

  def self.supported_providers
    PROVIDERS.keys
  end

  def self.authenticate(auth)
  if not supported_providers.include?(auth.provider)
    raise "Unsupported provider: #{auth.provider}"
  end

  identity = UserIdentity.find_by(
      provider: auth.provider,
      uid: auth.uid
    )

    return identity.user if identity

    user = User.find_by(email: auth.info.email) unless not auth.info.email?
    if user
      user.user_identities.create!(
          provider: auth.provider,
          uid: auth.uid
        )

      return user
    end

    parser = PROVIDERS[auth.provider]

    new_user = parser.parse(auth)

    User.transaction do
      user = User.new(new_user.fetch(:user))
      user.password = Devise.friendly_token(32)

      user.user_identities.build(
        new_user.fetch(:identity)
      )

      user.save!
      user
    end
  end
end
