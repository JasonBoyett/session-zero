# frozen_string_literal: true

{
  type: :object,
  required: %w[authenticated csrfToken userId],
  properties: {
    authenticated: { type: :boolean },
    csrfToken: { type: :string },
    userId: { type: :integer, nullable: true }
  }
}
