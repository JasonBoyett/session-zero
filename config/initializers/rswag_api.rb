if defined?(Rswag::Api)
  Rswag::Api.configure do |config|
    config.openapi_root = Rails.root.join("openapi").to_s
  end
end
