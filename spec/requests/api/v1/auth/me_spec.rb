# frozen_string_literal: true

require "swagger_helper"

RSpec.describe "Auth me API", type: :request do
  fixtures :users

  path "/auth/me" do
    get "Shows the current authenticated user" do
      operationId "getCurrentUser"
      tags "Auth"
      produces "application/json"

      response "200", "current authenticated user" do
        schema "$ref" => "#/components/schemas/CurrentUserResponse"

        before do
          sign_in users(:one)
        end

        run_test!
      end

      response "401", "unauthenticated" do
        run_test!
      end
    end

    patch "Updates the current authenticated user" do
      operationId "updateCurrentUser"
      tags "Auth"
      produces "application/json"
      consumes "application/json"
      parameter "$ref" => "#/components/parameters/CsrfToken"

      parameter name: :user,
        in: :body,
        required: true,
        schema: { "$ref" => "#/components/schemas/UpdateCurrentUserRequest" }

      let(:user) do
        {
          name: "Updated Name",
          profilePicture: "https://example.com/profile_picture.png"
        }
      end

      let(:"X-CSRF-Token") do
        get "/api/v1/auth/session"
        JSON.parse(response.body).fetch("csrfToken")
      end

      response "200", "current authenticated user" do
        schema "$ref" => "#/components/schemas/CurrentUserResponse"

        before do
          sign_in users(:one)
        end

        run_test! do
          body = JSON.parse(response.body)
          updated_user = users(:one).reload

          expect(updated_user.name).to eq("Updated Name")
          expect(updated_user.profile_picture)
            .to eq("https://example.com/profile_picture.png")
          expect(body["name"]).to eq("Updated Name")
          expect(body["profilePicture"])
            .to eq("https://example.com/profile_picture.png")
        end
      end

      response "401", "unauthenticated" do
        run_test!
      end
    end
  end
end
