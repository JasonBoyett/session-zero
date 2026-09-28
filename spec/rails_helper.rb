# frozen_string_literal: true

ENV["RAILS_ENV"] ||= "test"
ENV["CAMELIZE_API_JSON"] = "1"

require File.expand_path("../config/environment", __dir__)
require "rspec/rails"
require "rswag/specs"

Rails.root.glob("spec/support/**/*.rb").sort.each { |file| require file }

RSpec.configure do |config|
  config.fixture_paths = [Rails.root.join("test/fixtures")]
  config.use_transactional_fixtures = true
  config.include Devise::Test::IntegrationHelpers, type: :request
  config.infer_spec_type_from_file_location!
  config.filter_rails_from_backtrace!
end
