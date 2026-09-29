module Api
  module V1
    module Auth
      module Oauth
        class OauthCallbackController < ApplicationController
          DEFAULT_REDIRECT_PATH = "/auth/callback"

          def passthru
            head :not_found
          end

          def create
            validate_provider!

            auth = request.env.fetch("omniauth.auth")
            user = IdentityService.authenticate(auth)

            sign_in(:user, user)

            redirect_to client_redirect_url, allow_other_host: true
          end

          # def failure
          #   redirect_to client_redirect_url(error: params[:message].presence || "oauth_failed"),
          #     allow_other_host: true
          # end

          def failure
            error = request.env["omniauth.error"]

            Rails.logger.error <<~LOG
              OAuth failure:
                type: #{request.env["omniauth.error.type"].inspect}
                error: #{error.inspect}
                message: #{error&.message}
                backtrace:
                #{error&.backtrace&.first(20)&.join("\n")}
            LOG

            redirect_to client_redirect_url(
              error: params[:message].presence || "oauth_failed"
            ), allow_other_host: true
          end

          private

          def validate_provider!
            return if IdentityService.supported_providers.include?(params[:provider])

            raise ActionController::RoutingError, "Unsupported OAuth provider"
          end

          def client_redirect_url(error: nil)
            uri = URI.join(Rails.application.config.x.client_url, redirect_path)

            if error
              query = Rack::Utils.parse_nested_query(uri.query)
              query["error"] = error
              uri.query = query.to_query
            end

            uri.to_s
          end

          def redirect_path
            path = params[:redirect].presence ||
              request.env["omniauth.origin"].presence ||
              params[:origin].presence ||
              DEFAULT_REDIRECT_PATH

            normalized_path = path.to_s.strip.sub(%r{\A/+}, "")

            "/#{normalized_path}"
          end
        end
      end
    end
  end
end
