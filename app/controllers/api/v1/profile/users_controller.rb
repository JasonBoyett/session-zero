module Api
  module V1
    module Profile
      class UsersController < ApplicationController
        before_action :require_authenticated_user

        def show
          render json: User.find(params[:id]).profile_attributes_for(current_user.id)
        end

        private

        def require_authenticated_user
          head :unauthorized unless user_signed_in?
        end
      end
    end
  end
end
