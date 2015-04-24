require 'ivy/serializers/documents/document'
require 'ivy/serializers/documents/individual_resource'
require 'ivy/serializers/documents/resource_collection'

module Ivy
  module Serializers
    module Documents
      def self.create(serializer, primary_resource_name, primary_resource)
        klass = document_class_for(primary_resource)
        klass.new(serializer, primary_resource_name, primary_resource)
      end

      def self.document_class_for(resource)
        resource.respond_to?(:to_ary) ? ResourceCollection : IndividualResource
      end
    end
  end
end
