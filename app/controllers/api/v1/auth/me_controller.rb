module Api
  module V1
    module Auth
      class MeController < ApplicationController
        before_action :authenticate_user!

        def show
          render json: user_response
        end

        def update
          current_user.update!(user_params)
          render json: user_response
        end

        private

        def user_params
          params.permit(*User.updatable_attributes)
        end

        def user_response
          current_user.user_visible_attributes
        end
      end
    end
  end
end
