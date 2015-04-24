require 'ivy/serializers/relationships/relationship'

module Ivy
  module Serializers
    module Relationships
      class HasMany < Relationship
        def generate(generator, resource)
          generator.has_many(@name, get(resource), @options)
        end
      end
    end
  end
end
