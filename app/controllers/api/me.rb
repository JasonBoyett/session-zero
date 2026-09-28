module Api
  module V1
    module Me
      class SessionsController < ApplicationController
        def show
          render json: {
            authenticated: user_signed_in?,
            csrf_token: form_authenticity_token,
            user_id: current_user&.id
          }
        end


        def destroy
          sign_out :user

          render_session
        end

        def create
          return head :not_found unless Rails
            .application.config.x.password_login_enabled

          user = User.find_by(email: params[:email].to_s.downcase)
          if user&.valid_password?(params[:password])
            sign_in :user, user
            render_session
          else
            render json: { error: "invalid_credentials" }, status: :unauthorized
          end
        end

        private

        def render_session
          render json: {
            authenticated: user_signed_in?,
            csrf_token: form_authenticity_token,
            user_id: current_user&.id
          }
        end
      end
    end
  end
end
