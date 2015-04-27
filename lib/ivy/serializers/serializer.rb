require 'ivy/serializers/registry'

module Ivy
  module Serializers
    class Serializer
      attr_reader :_registry

      def initialize
        @_registry = Registry.new
      end

      def links(generator, resource)
        _registry.links(generator, resource)
      end

      def map(klass, &block)
        _registry.map(klass, &block)
      end

      def resource(generator, resource)
        _registry.resource(generator, resource)
      end
    end
  end
end
