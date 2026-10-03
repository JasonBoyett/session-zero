# frozen_string_literal: true

{
  type: :object,
  required: %w[id name profilePicture bio systems isUserPublic],
  properties: {
    id: { type: :integer },
    userId: { type: :integer },
    name: { type: :string, nullable: true },
    profilePicture: { type: :string, nullable: true },
    bio: { type: :string, nullable: true },
    systems: {
      type: :array,
      items: { type: :string }
    },
    isUserPublic: { type: :boolean },
    createdAt: { type: :string, format: "date-time" },
    lastUsedAt: { type: :string, format: "date-time" },
    canEdit: { type: :boolean }
  }
}
