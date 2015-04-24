module Ivy
  module Serializers
    class Attribute
      def initialize(name, options={})
        @name = name
        @key  = options.fetch(:as, @name)
      end

      def generate(generator, resource)
        generator.attribute(@key, get(resource))
      end

      private

      def get(resource)
        resource.public_send(@name)
      end
    end
  end
end
