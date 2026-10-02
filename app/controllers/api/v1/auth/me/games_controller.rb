module Api
  module V1
    module Auth
      module Me
        class GamesController < ApplicationController
          before_action :require_authenticated_user

          def index
            render json: {
              gm_identities: gm_identities,
              games_as_player: games_as_player
            }
          end

          private

          def require_authenticated_user
            head :unauthorized unless user_signed_in?
          end

          def gm_identities
            current_user
              .game_master_profiles
              .includes(games: :player_profiles)
              .order(:id)
              .map do |profile|
                {
                  id: profile.id,
                  display_name: profile.name,
                  profile_picture: profile.profile_picture,
                  games: profile.games.sort_by(&:id).map do |game|
                    game_summary_as_gm(game)
                  end
                }
              end
          end

          def games_as_player
            current_user
              .player_profiles
              .includes(game: [ :player_profiles, :game_master_profile ])
              .order(:id)
              .map do |profile|
                game_summary_as_player(profile)
              end
          end

          def game_summary_as_gm(game)
            {
              id: game.id,
              name: game.name,
              system: game.system,
              description: game.description,
              player_count: game.player_profiles.size
            }
          end

          def game_summary_as_player(player_profile)
            game_summary_as_gm(player_profile.game).merge(
              player_profile: player_profile_summary(player_profile),
              gm_profile: gm_profile_summary(player_profile.game.game_master_profile)
            )
          end

          def player_profile_summary(profile)
            {
              id: profile.id,
              display_name: profile.character_name,
              profile_picture: profile.character_image
            }
          end

          def gm_profile_summary(profile)
            {
              id: profile.id,
              display_name: profile.name,
              profile_picture: profile.profile_picture
            }
          end
        end
      end
    end
  end
end
