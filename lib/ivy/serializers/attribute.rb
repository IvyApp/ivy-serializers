module Ivy
  module Serializers
    class Attribute
      def initialize(name, &getter)
        @name = name
        @getter = getter || method(:default_getter)
      end

      def generate(generator, resource)
        generator.attribute(@name, get(resource))
      end

      private

      def default_getter(resource)
        resource.public_send(@name)
      end

      def get(resource)
        @getter.call(resource) if resource
      end
    end
  end
end
