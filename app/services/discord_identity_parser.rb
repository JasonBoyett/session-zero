class DiscordIdentityParser
  def self.parse(auth)
    {
      user: {
        name: auth.info.name,
        email: auth.info.email,
        profile_picture: auth.info.image
      },
      identity: {
        provider: auth.provider,
        uid: auth.uid
      }
    }
  end
end
