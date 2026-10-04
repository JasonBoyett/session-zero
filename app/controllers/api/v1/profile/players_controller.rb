module Api
  module V1
    module Profile
      class PlayersController < ApplicationController
        before_action :require_authenticated_user

        def show
          render json: PlayerProfile
            .find(params[:id])
            .profile_attributes_for(current_user.id)
        end

        def update
          profile = PlayerProfile.find(params[:id])
          update_params = profile_update_params

          if profile.update_allowed_for?(current_user.id)
            profile.update!(update_params)
            render json: { error: nil }, status: :ok
          else
            render json: { error: "not_authorized" }, status: :forbidden
          end
        end

        private

        def require_authenticated_user
          head :unauthorized unless user_signed_in?
        end

        def profile_update_params
          params.permit(*PlayerProfile.updatable_attributes)
        end
      end
    end
  end
end
