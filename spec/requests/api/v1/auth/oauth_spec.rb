# frozen_string_literal: true

require "swagger_helper"

RSpec.describe "Auth OAuth API", type: :request do
  fixtures :users, :user_identities

  around do |example|
    previous_client_url = Rails.application.config.x.client_url
    previous_test_mode = OmniAuth.config.test_mode
    previous_mock_auth = OmniAuth.config.mock_auth.dup

    Rails.application.config.x.client_url = "http://client.example"
    OmniAuth.config.test_mode = true
    example.run
  ensure
    Rails.application.config.x.client_url = previous_client_url
    OmniAuth.config.test_mode = previous_test_mode
    OmniAuth.config.mock_auth = previous_mock_auth
  end

  let(:provider) { "discord" }
  let(:redirect) { "/games" }
  let(:message) { "csrf_detected" }

  let(:discord_auth) do
    OmniAuth::AuthHash.new(
      provider: "discord",
      uid: user_identities(:one).uid,
      info: {
        email: users(:one).email
      }
    )
  end

  path "/auth/oauth/{provider}" do
    post "Starts OAuth for a provider" do
      operationId "startOauth"
      tags "Auth"
      parameter "$ref" => "#/components/parameters/CsrfToken"
      parameter name: :provider,
        in: :path,
        required: true,
        schema: { type: :string, enum: %w[discord] }
      parameter name: :redirect,
        in: :query,
        required: false,
        schema: { type: :string }

      let(:"X-CSRF-Token") do
        get "/api/v1/auth/session"
        JSON.parse(response.body).fetch("csrfToken")
      end

      response "302", "redirect to provider authorization flow" do
        header "Location", schema: { type: :string, format: :uri }

        before do
          OmniAuth.config.mock_auth[:discord] = discord_auth
        end

        run_test!
      end
    end
  end

  path "/auth/oauth/{provider}/callback" do
    get "Handles OAuth callback for a provider" do
      operationId "handleOauthCallback"
      tags "Auth"
      parameter name: :provider,
        in: :path,
        required: true,
        schema: { type: :string, enum: %w[discord] }
      parameter name: :redirect,
        in: :query,
        required: false,
        schema: { type: :string }

      response "302", "redirect to client application" do
        header "Location", schema: { type: :string, format: :uri }

        before do
          OmniAuth.config.mock_auth[:discord] = discord_auth
        end

        run_test! do
          expect(response).to redirect_to("http://client.example/games")
        end
      end
    end
  end

  path "/auth/oauth/failure" do
    get "Handles OAuth failure" do
      operationId "handleOauthFailure"
      tags "Auth"
      parameter name: :redirect,
        in: :query,
        required: false,
        schema: { type: :string }
      parameter name: :origin,
        in: :query,
        required: false,
        schema: { type: :string }
      parameter name: :message,
        in: :query,
        required: false,
        schema: { type: :string }

      response "302", "redirect to client application with error" do
        header "Location", schema: { type: :string, format: :uri }

        run_test! do
          expect(response).to redirect_to("http://client.example/games?error=csrf_detected")
        end
      end
    end
  end
end
