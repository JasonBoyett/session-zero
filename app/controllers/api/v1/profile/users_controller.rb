module Api
  module V1
    module Profile
      class UsersController < ApplicationController
        before_action :require_authenticated_user

        def show
          render json: User.find(params[:id]).profile_page_payload_for(current_user.id)
        end

        def update
          profile = User.find(params[:id])
          if profile.update_allowed_for?(current_user.id)
            profile.update!(profile_update_params)
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
          params.permit(*User.updatable_attributes)
        end
      end
    end
  end
end
