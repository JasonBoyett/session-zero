# frozen_string_literal: true

{
  type: :object,
  required: %w[id name system description playerCount],
  properties: {
    id: { type: :integer },
    name: { type: :string, nullable: true },
    system: { type: :string, nullable: true },
    description: { type: :string, nullable: true },
    playerCount: { type: :integer }
  }
}
