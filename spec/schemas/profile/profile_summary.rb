# frozen_string_literal: true

{
  type: :object,
  required: %w[id displayName profilePicture],
  properties: {
    id: { type: :integer },
    displayName: { type: :string, nullable: true },
    profilePicture: { type: :string, nullable: true }
  }
}
