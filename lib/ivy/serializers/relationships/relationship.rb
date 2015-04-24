module Ivy
  module Serializers
    module Relationships
      class Relationship
        def initialize(name, options={}, &getter)
          @name = name
          @options = options
          @getter = getter || method(:default_getter)
        end

        private

        def default_getter(resource)
          resource.public_send(@name)
        end

        def get(resource)
          @getter.call(resource)
        end
      end
    end
  end
end
