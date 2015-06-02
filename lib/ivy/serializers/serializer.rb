require 'ivy/serializers/registry'

module Ivy
  module Serializers
    class Serializer
      class << self
        attr_accessor :_registry

        def attributes(generator, resource)
          _registry.attributes(generator, resource)
        end

        def inherited(base)
          base._registry = Registry.new
        end

        def relationships(generator, resource)
          _registry.relationships(generator, resource)
        end

        def map(klass, &block)
          _registry.map(klass, &block)
        end

        def resource(generator, resource)
          _registry.resource(generator, resource)
        end
      end

      def attributes(generator, resource)
        self.class.attributes(generator, resource)
      end

      def relationships(generator, resource)
        self.class.relationships(generator, resource)
      end

      def resource(generator, resource)
        self.class.resource(generator, resource)
      end
    end
  end
end
