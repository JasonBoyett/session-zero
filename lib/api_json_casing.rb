module ApiJsonCasing
  TRUE_VALUES = [true, "true", "1"].freeze
  NON_API_ROUTE = ->(env) { !env["PATH_INFO"].match?(%r{^/api}) }

  def self.enabled?(env_value:, rails_env:)
    value = env_value.nil? ? rails_env.to_s != "test" : env_value

    TRUE_VALUES.include?(value)
  end

  def self.enabled_from_environment(env: ENV, rails_env: Rails.env)
    enabled?(env_value: env["CAMELIZE_API_JSON"], rails_env: rails_env)
  end

  def self.middleware_options
    {
      inflection: "camel",
      exclude_params: NON_API_ROUTE,
      exclude_response: NON_API_ROUTE
    }
  end
end
