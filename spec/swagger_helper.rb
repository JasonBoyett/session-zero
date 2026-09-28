# frozen_string_literal: true

require "rails_helper"

RSpec.configure do |config|
  config.openapi_root = Rails.root.join("openapi").to_s

  config.openapi_specs = {
    "v1.json" => {
      openapi: "3.0.3",
      info: {
        title: "Session Zero API",
        version: "v1"
      },
      paths: {},
      servers: [
        {
          url: "/api/v1"
        }
      ],
      components: {
        parameters: {
          CsrfToken: {
            name: "X-CSRF-Token",
            in: :header,
            required: true,
            schema: { type: :string }
          }
        },
        schemas: {
          AuthResponse: {
            type: :object,
            required: %w[authenticated csrfToken userId],
            properties: {
              authenticated: { type: :boolean },
              csrfToken: { type: :string },
              userId: { type: :integer, nullable: true }
            }
          },
          CreateAuthSessionRequest: {
            type: :object,
            required: %w[email password],
            properties: {
              email: { type: :string, format: :email },
              password: { type: :string }
            }
          },
          ErrorResponse: {
            type: :object,
            required: %w[error],
            properties: {
              error: { type: :string }
            }
          },
          CurrentUserResponse: {
            type: :object,
            required: User.user_visible_attributes_for_openapi,
            properties: {
              id: { type: :integer },
              email: { type: :string, format: :email, nullable: true },
              name: { type: :string, nullable: true },
              profilePicture: { type: :string, nullable: true },
              createdAt: { type: :string, format: "date-time" },
              updatedAt: { type: :string, format: "date-time" }
            }
          },
          UpdateCurrentUserRequest: {
            type: :object,
            properties: User.updatable_attributes_for_openapi
          }
        }
      }
    }
  }

  config.openapi_format = :json
end
