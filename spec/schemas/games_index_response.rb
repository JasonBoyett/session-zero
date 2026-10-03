# frozen_string_literal: true

{
  type: :object,
  "x-type-aliases" => {
    "GamesIndexGmIdentity" => "gmIdentities[number]",
    "GamesIndexGameAsGm" => "gmIdentities[number].games[number]",
    "GamesIndexGameAsPlayer" => "gamesAsPlayer[number]"
  },
  required: %w[gmIdentities gamesAsPlayer],
  properties: {
    gmIdentities: {
      type: :array,
      items: {
        "$ref" => "#/components/schemas/GmIdentitySummary"
      }
    },
    gamesAsPlayer: {
      type: :array,
      items: {
        "$ref" => "#/components/schemas/GameSummaryAsPlayer"
      }
    }
  }
}
