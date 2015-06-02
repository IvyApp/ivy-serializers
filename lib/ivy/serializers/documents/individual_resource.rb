require 'ivy/serializers/documents/document'

module Ivy
  module Serializers
    module Documents
      class IndividualResource < Document
        def generate_included(generator)
          @serializer.relationships(self, @primary_resource)
          super
        end

        def generate_primary_resource(generator)
          generator.primary_resource(@primary_resource_name, @primary_resource)
        end
      end
    end
  end
end
