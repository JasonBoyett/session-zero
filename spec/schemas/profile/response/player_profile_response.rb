# frozen_string_literal: true

{
  type: :object,
  required: %w[
    id
    characterName
    characterImage
    characterDescription
    isAccepted
    isUserPublic
  ],
  properties: {
    id: { type: :integer },
    userId: { type: :integer },
    characterName: { type: :string, nullable: true },
    characterImage: { type: :string, nullable: true },
    characterDescription: { type: :string, nullable: true },
    characterSheetLink: { type: :string, nullable: true },
    isAccepted: { type: :boolean },
    isUserPublic: { type: :boolean },
    createdAt: { type: :string, format: "date-time" },
    lastUsedAt: { type: :string, format: "date-time" },
    canEdit: { type: :boolean },
    canAccept: { type: :boolean }
  }
}
