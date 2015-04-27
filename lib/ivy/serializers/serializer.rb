require 'ivy/serializers/registry'

module Ivy
  module Serializers
    class Serializer
      class << self
        attr_accessor :_registry

        def inherited(base)
          base._registry = Registry.new
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

      def links(generator, links)
        self.class.links(generator, links)
      end

      def resource(generator, resource)
        self.class.resource(generator, resource)
      end
    end
  end
end
