# frozen_string_literal: true

require "swagger_helper"

RSpec.describe "Auth session API", type: :request do
  fixtures :users

  shared_examples "password login" do
    tags "Auth"
    consumes "application/json"
    produces "application/json"
    parameter "$ref" => "#/components/parameters/CsrfToken"
    parameter name: :credentials,
      in: :body,
      required: true,
      schema: { "$ref" => "#/components/schemas/CreateAuthSessionRequest" }

    let(:"X-CSRF-Token") do
      get "/api/v1/auth/session"
      JSON.parse(response.body).fetch("csrfToken")
    end

    response "200", "authenticated session" do
      let(:credentials) do
        {
          email: users(:one).email,
          password: "password"
        }
      end

      schema "$ref" => "#/components/schemas/AuthResponse"

      run_test!
    end

    response "401", "invalid credentials" do
      let(:credentials) do
        {
          email: users(:one).email,
          password: "wrong-password"
        }
      end

      schema "$ref" => "#/components/schemas/ErrorResponse"

      run_test!
    end

    response "404", "password login is disabled" do
      around do |example|
        previous = Rails.application.config.x.password_login_enabled
        Rails.application.config.x.password_login_enabled = false
        example.run
      ensure
        Rails.application.config.x.password_login_enabled = previous
      end

      let(:credentials) do
        {
          email: users(:one).email,
          password: "password"
        }
      end

      run_test!
    end
  end

  path "/auth/login" do
    post "Logs in with email and password" do
      operationId "login"

      include_examples "password login"
    end
  end

  path "/auth/session" do
    get "Shows the current auth session" do
      operationId "getAuthSession"
      tags "Auth"
      produces "application/json"

      response "200", "current authentication session" do
        schema "$ref" => "#/components/schemas/AuthResponse"

        run_test!
      end
    end

    post "Creates an auth session" do
      operationId "createAuthSession"

      include_examples "password login"
    end

    delete "Destroys the current auth session" do
      operationId "destroyAuthSession"
      tags "Auth"
      produces "application/json"
      parameter "$ref" => "#/components/parameters/CsrfToken"

      let(:"X-CSRF-Token") do
        get "/api/v1/auth/session"
        JSON.parse(response.body).fetch("csrfToken")
      end

      response "200", "unauthenticated session" do
        schema "$ref" => "#/components/schemas/AuthResponse"

        run_test!
      end
    end
  end
end
