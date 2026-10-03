# frozen_string_literal: true

{
  allOf: [
    { "$ref" => "#/components/schemas/GameSummary" },
    {
      type: :object,
      required: %w[playerProfile gmProfile],
      properties: {
        playerProfile: {
          "$ref" => "#/components/schemas/ProfileSummary"
        },
        gmProfile: {
          "$ref" => "#/components/schemas/ProfileSummary"
        }
      }
    }
  ]
}
