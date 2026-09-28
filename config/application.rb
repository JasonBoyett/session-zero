require_relative "boot"
require_relative "../lib/api_json_casing"

require "rails/all"
require "uri"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Api
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 8.1

    # Please, add to the `ignore` list any other `lib` subdirectories that do
    # not contain `.rb` files, or that should not be reloaded or eager loaded.
    # Common ones are `templates`, `generators`, or `middleware`, for example.
    config.autoload_lib(ignore: %w[assets tasks])

    config.x.client_url = ENV.fetch("CLIENT_URL").delete_suffix("/")
    config.x.api_url = ENV.fetch("API_URL").delete_suffix("/")
    config.x.password_login_enabled = !Rails.env.production?
    config.x.camelize_api_json = ApiJsonCasing.enabled_from_environment

    api_url = URI.parse(config.x.api_url)
    config.action_mailer.default_url_options = {
      host: api_url.host,
      port: api_url.port,
      protocol: api_url.scheme
    }

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")

    # Only loads a smaller set of middleware suitable for API only apps.
    # Middleware like session, flash, cookies can be added back manually.
    # Skip views, helpers and assets when generating a new resource.
    config.api_only = true

    config.session_store :cookie_store,
      key: ENV.fetch("SESSION_COOKIE_NAME"),
      same_site: :lax,
      secure: Rails.env.production?,
      httponly: true

    config.middleware.insert_before(0, ActionDispatch::Cookies)
    config.middleware.insert_after(
      ActionDispatch::Cookies,
      config.session_store,
      config.session_options
    )

    if config.x.camelize_api_json
      config.middleware.use OliveBranch::Middleware, **ApiJsonCasing.middleware_options
    end
  end
end
