module Ivy
  module Serializers
    class Attribute
      def initialize(name)
        @name = name
      end

      def generate(generator, resource)
        generator.attribute(@name, resource.public_send(@name))
      end
    end
  end
end
