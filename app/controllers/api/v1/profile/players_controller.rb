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

        private

        def require_authenticated_user
          head :unauthorized unless user_signed_in?
        end
      end
    end
  end
end
