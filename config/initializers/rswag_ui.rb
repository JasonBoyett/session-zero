if defined?(Rswag::Ui)
  Rswag::Ui.configure do |config|
    config.openapi_endpoint "/api-docs/v1.json", "Session Zero API V1"
  end
end
