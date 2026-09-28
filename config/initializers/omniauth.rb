OmniAuth.config.allowed_request_methods = [ :post ]
OmniAuth.config.path_prefix = "/api/v1/auth/oauth"

OmniAuth.config.request_validation_phase =
  OmniAuth::AuthenticityTokenProtection.new(key: :_csrf_token)

OmniAuth.config.on_failure = lambda do |env|
  Api::V1::Auth::Oauth::OauthCallbackController.action(:failure).call(env)
end
