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
          },
          ProfileSummary: {
            type: :object,
            required: %w[id displayName profilePicture],
            properties: {
              id: { type: :integer },
              displayName: { type: :string, nullable: true },
              profilePicture: { type: :string, nullable: true }
            }
          },
          GameSummary: {
            type: :object,
            required: %w[id name description playerCount],
            properties: {
              id: { type: :integer },
              name: { type: :string, nullable: true },
              description: { type: :string, nullable: true },
              playerCount: { type: :integer }
            }
          },
          GameSummaryAsGm: {
            allOf: [
              { "$ref" => "#/components/schemas/GameSummary" }
            ]
          },
          GameSummaryAsPlayer: {
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
          },
          GmIdentitySummary: {
            type: :object,
            required: %w[id displayName profilePicture games],
            properties: {
              id: { type: :integer },
              displayName: { type: :string, nullable: true },
              profilePicture: { type: :string, nullable: true },
              games: {
                type: :array,
                items: {
                  "$ref" => "#/components/schemas/GameSummaryAsGm"
                }
              }
            }
          },
          GamesIndexResponse: {
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
        }
      }
    }
  }

  config.openapi_format = :json
end
