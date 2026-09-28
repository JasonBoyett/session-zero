OmniAuth.config.allowed_request_methods = [ :post ]
OmniAuth.config.path_prefix = "/api/v1/auth/oauth"

OmniAuth.config.request_validation_phase =
  OmniAuth::AuthenticityTokenProtection.new(key: :_csrf_token)
