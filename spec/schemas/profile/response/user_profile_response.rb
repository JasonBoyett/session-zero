# frozen_string_literal: true

{
  type: :object,
  required: %w[id name profilePicture],
  properties: {
    id: { type: :integer },
    name: { type: :string, nullable: true },
    profilePicture: { type: :string, nullable: true },
    email: { type: :string, nullable: true },
    createdAt: { type: :string, format: "date-time" },
    updatedAt: { type: :string, format: "date-time" },
    canEdit: { type: :boolean }
  }
}
