require 'ivy/serializers/relationships/relationship'

module Ivy
  module Serializers
    module Relationships
      class BelongsTo < Relationship
        def generate(generator, resource)
          generator.belongs_to(@name, get(resource), @options)
        end
      end
    end
  end
end
