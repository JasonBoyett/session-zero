# spec/swagger_loader.rb
# frozen_string_literal: true

module SwaggerSchemaLoader
  SCHEMA_ROOT = Rails.root.join("spec", "schemas")

  SCHEMA_DEFINITION_KEYS = %i[
    type
    allOf
    oneOf
    anyOf
    not
    enum
  ].freeze

  def self.load(schema_root = SCHEMA_ROOT)
    schemas = {}
    sources = {}

    Dir.glob(schema_root.join("**", "*.rb").to_s).sort.each do |file|
      name = File.basename(file, ".rb").camelize.to_sym

      if schemas.key?(name)
        raise <<~ERROR
          Duplicate OpenAPI schema: #{name}

          #{sources[name]}
          #{file}

          Schema filenames must be globally unique.
        ERROR
      end

      schema = eval(File.read(file), binding, file)

      validate_schema!(file, schema)

      schemas[name] = schema
      sources[name] = file
    end

    schemas
  end

  def self.validate_schema!(file, schema)
    unless schema.is_a?(Hash)
      raise "#{file} must evaluate to a Hash"
    end

    unless SCHEMA_DEFINITION_KEYS.any? { |key| schema.key?(key) }
      raise <<~ERROR
        Invalid OpenAPI schema: #{file}

        Schema must define at least one of:
        #{SCHEMA_DEFINITION_KEYS.join(", ")}
      ERROR
    end

    if schema.key?(:properties) && schema[:type] != :object
      raise <<~ERROR
        Invalid OpenAPI schema: #{file}

        Schema defines properties but is not type: :object.
      ERROR
    end

    if schema.key?(:required) && !schema.key?(:properties)
      raise <<~ERROR
        Invalid OpenAPI schema: #{file}

        Schema defines required fields but has no properties.
      ERROR
    end
  end

  private_class_method :validate_schema!
end
