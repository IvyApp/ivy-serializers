require 'ivy/serializers/attribute'
require 'ivy/serializers/relationships'

module Ivy
  module Serializers
    class Mapping
      def initialize(klass)
        @attributes = {}
        @relationships = {}
        @klass = klass
      end

      def attribute(name, &block)
        @attributes[name] = Attribute.new(name, &block)
      end

      def attributes(*names)
        names.each { |name| attribute(name) }
      end

      def belongs_to(name, options={}, &block)
        @relationships[name] = Relationships::BelongsTo.new(name, options, &block)
      end

      def generate_attributes(generator, resource)
        @attributes.each_value { |attribute| attribute.generate(generator, resource) }
      end

      def has_many(name, options={}, &block)
        @relationships[name] = Relationships::HasMany.new(name, options, &block)
      end

      def relationships(generator, resource)
        @relationships.each_value { |relationship| relationship.generate(generator, resource) }
      end

      def resource(generator, resource)
        generator.attributes(resource) unless @attributes.empty?
        generator.relationships(resource) unless @relationships.empty?
      end
    end
  end
end
