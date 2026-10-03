# frozen_string_literal: true

{
  type: :object,
  required: %w[email password],
  properties: {
    email: { type: :string, format: :email },
    password: { type: :string }
  }
}
