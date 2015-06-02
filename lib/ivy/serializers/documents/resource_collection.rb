require 'ivy/serializers/documents/document'

module Ivy
  module Serializers
    module Documents
      class ResourceCollection < Document
        def generate_linked(generator)
          @primary_resource.each { |resource| @serializer.relationships(self, resource) }
          super
        end

        def generate_primary_resource(generator)
          generator.primary_resources(@primary_resource_name, @primary_resource)
        end
      end
    end
  end
end
