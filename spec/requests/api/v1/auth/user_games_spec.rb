# frozen_string_literal: true

require "swagger_helper"

RSpec.describe "Auth user games API", type: :request do
  fixtures :users,
    :game_master_profiles,
    :games,
    :player_profiles

  path "/auth/me/games" do
    get "Lists games associated with the current user's profiles" do
      operationId "getCurrentUserGames"
      tags "Auth"
      produces "application/json"

      response "200", "current user's profile-grouped games" do
        schema "$ref" => "#/components/schemas/GamesIndexResponse"

        before do
          sign_in users(:one)
        end

        run_test!
      end

      response "401", "unauthenticated" do
        run_test!
      end
    end
  end
end
