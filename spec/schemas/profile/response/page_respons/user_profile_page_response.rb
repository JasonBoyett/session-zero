# frozen_string_literal: true

{
  type: :object,
  required: %w[userInfo gmProfiles playerProfiles],
  properties: {
    userInfo: {
      "$ref" => "#/components/schemas/UserProfileResponse"
    },
    gmProfiles: {
      type: :array,
      items: {
        "$ref" => "#/components/schemas/GmProfileResponse"
      }
    },
    playerProfiles: {
      type: :array,
      items: {
        "$ref" => "#/components/schemas/PlayerProfileResponse"
      }
    }
  }
}
