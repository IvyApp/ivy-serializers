module Ivy
  module Serializers
    module Relationships
      class Relationship
        def initialize(name, options={})
          @name = name
          @options = options
        end

        def get(resource)
          resource.public_send(@name)
        end
      end
    end
  end
end
