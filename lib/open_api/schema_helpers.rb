# frozen_string_literal: true

module OpenApi
  module SchemaHelpers
    def self.updatable_properties_for(model)
      model.updatable_attributes.to_h do |attribute|
        column = model.columns_hash.fetch(attribute.to_s)

        [
          attribute.to_s.camelize(:lower).to_sym,
          openapi_schema_for(column).merge(nullable: column.null)
        ]
      end
    end

    def self.openapi_schema_for(column)
      case column.type
      when :string, :text
        { type: :string }
      when :integer
        { type: :integer }
      when :float, :decimal
        { type: :number }
      when :boolean
        { type: :boolean }
      when :date
        { type: :string, format: :date }
      when :datetime, :timestamp
        { type: :string, format: :"date-time" }
      when :json
        { type: :array, items: { type: :string } }
      else
        raise "Unsupported ActiveRecord type for OpenAPI: #{column.type}"
      end
    end

    private_class_method :openapi_schema_for
  end
end
