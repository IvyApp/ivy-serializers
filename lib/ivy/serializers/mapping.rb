require 'ivy/serializers/attribute'
require 'ivy/serializers/relationships'

module Ivy
  module Serializers
    class Mapping
      def initialize(klass)
        @attrs = {}
        @links = {}
        @klass = klass
      end

      def attribute(name, &block)
        @attrs[name] = Attribute.new(name, &block)
      end

      def attributes(*names)
        names.each { |name| attribute(name) }
      end

      def belongs_to(name, options={}, &block)
        @links[name] = Relationships::BelongsTo.new(name, options, &block)
      end

      def generate_attributes(generator, resource)
        @attrs.each_value { |attr| attr.generate(generator, resource) }
      end

      def has_many(name, options={}, &block)
        @links[name] = Relationships::HasMany.new(name, options, &block)
      end

      def links(generator, resource)
        @links.each_value { |link| link.generate(generator, resource) }
      end

      def resource(generator, resource)
        generator.attributes(resource) unless @attrs.empty?
        generator.links(resource) unless @links.empty?
      end
    end
  end
end
