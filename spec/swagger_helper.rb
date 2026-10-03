# frozen_string_literal: true

require "rails_helper"
require_relative "swagger_loader"

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
        schemas: SwaggerSchemaLoader.load
      }
    }
  }

  config.openapi_format = :json
end
