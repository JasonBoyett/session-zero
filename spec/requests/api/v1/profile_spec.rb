# frozen_string_literal: true

require "swagger_helper"

RSpec.describe "Profile API", type: :request do
  fixtures :users,
    :game_master_profiles,
    :games,
    :player_profiles

  path "/profile/user/{id}" do
    parameter name: :id, in: :path, type: :integer, required: true

    get "Shows a user profile" do
      operationId "getUserProfile"
      tags "Profile"
      produces "application/json"

      let(:id) { users(:one).id }

      response "200", "user profile" do
        schema "$ref" => "#/components/schemas/UserProfilePageResponse"

        before do
          sign_in users(:one)
        end

        run_test!
      end

      response "401", "unauthenticated" do
        run_test!
      end

      response "404", "missing user profile" do
        let(:id) { 0 }

        before do
          sign_in users(:one)
        end

        run_test!
      end
    end

    patch "Updates a user profile" do
      operationId "updateUserProfile"
      tags "Profile"
      consumes "application/json"
      produces "application/json"

      parameter "$ref" => "#/components/parameters/CsrfToken"

      parameter name: :user_profile,
        in: :body,
        required: true,
        schema: { "$ref" => "#/components/schemas/UpdateUserProfileRequest" }

      let(:id) { users(:one).id }
      let(:user_profile) { { name: "Updated User One" } }

      let(:"X-CSRF-Token") do
        get "/api/v1/auth/session"
        JSON.parse(response.body).fetch("csrfToken")
      end

      response "200", "user profile updated" do
        before { sign_in users(:one) }

        run_test!
      end
    end
  end

  path "/profile/gm/{id}" do
    parameter name: :id, in: :path, type: :integer, required: true

    get "Shows a GM profile" do
      operationId "getGmProfile"
      tags "Profile"
      produces "application/json"

      let(:id) { game_master_profiles(:one).id }

      response "200", "GM profile" do
        schema "$ref" => "#/components/schemas/GmProfileResponse"

        before do
          sign_in users(:one)
        end

        run_test!
      end

      response "401", "unauthenticated" do
        run_test!
      end

      response "404", "missing GM profile" do
        let(:id) { 0 }

        before do
          sign_in users(:one)
        end

        run_test!
      end
    end

    patch "Updates a GM profile" do
      operationId "updateGmProfile"
      tags "Profile"
      consumes "application/json"

      parameter "$ref" => "#/components/parameters/CsrfToken"

      parameter name: :gm_profile,
        in: :body,
        required: true,
        schema: { "$ref" => "#/components/schemas/UpdateGmProfileRequest" }

      let(:id) { game_master_profiles(:one).id }
      let(:gm_profile) { { name: "Updated GM" } }

      let(:"X-CSRF-Token") do
        get "/api/v1/auth/session"
        JSON.parse(response.body).fetch("csrfToken")
      end

      response "200", "GM profile updated" do
        before { sign_in users(:one) }

        run_test!
      end
    end
  end

  path "/profile/player/{id}" do
    parameter name: :id, in: :path, type: :integer, required: true

    get "Shows a player profile" do
      operationId "getPlayerProfile"
      tags "Profile"
      produces "application/json"

      let(:id) { player_profiles(:one).id }

      response "200", "player profile" do
        schema "$ref" => "#/components/schemas/PlayerProfileResponse"

        before do
          sign_in users(:one)
        end

        run_test!
      end

      response "401", "unauthenticated" do
        run_test!
      end

      response "404", "missing player profile" do
        let(:id) { 0 }

        before do
          sign_in users(:one)
        end

        run_test!
      end
    end

    patch "Updates a player profile" do
      operationId "updatePlayerProfile"
      tags "Profile"
      consumes "application/json"

      parameter "$ref" => "#/components/parameters/CsrfToken"

      parameter name: :player_profile,
        in: :body,
        required: true,
        schema: { "$ref" => "#/components/schemas/UpdatePlayerProfileRequest" }

      let(:id) { player_profiles(:one_in_two).id }
      let(:player_profile) { { characterName: "Updated Player" } }

      let(:"X-CSRF-Token") do
        get "/api/v1/auth/session"
        JSON.parse(response.body).fetch("csrfToken")
      end

      response "200", "player profile updated" do
        before { sign_in users(:one) }

        run_test!
      end
    end
  end
end
