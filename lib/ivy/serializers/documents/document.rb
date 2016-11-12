require 'set'

module Ivy
  module Serializers
    module Documents
      class Document
        def initialize(serializer, primary_resource_name, primary_resource)
          @serializer = serializer
          @primary_resource_name = primary_resource_name
          @primary_resource = primary_resource
          @included_resources = Hash.new { |hash, klass| hash[klass] = Set.new }
        end

        def belongs_to(name, resource, options={})
          include_resource(resource) if resource && options[:embed_in_root]
        end

        def generate(generator)
          generator.document(self)
        end

        def generate_attributes(generator, resource)
          @serializer.attributes(generator, resource)
        end

        def generate_included(generator)
          generator.included(self) unless @included_resources.empty?
        end

        def generate_included_resources(generator)
          generator.included_resources(@included_resources)
        end

        def generate_relationships(generator, resource)
          @serializer.relationships(generator, resource)
        end

        def generate_resource(generator, resource)
          @serializer.resource(generator, resource)
        end

        def has_many(name, resources, options={})
          include_resources(resources) if options[:embed_in_root]
        end

        private

        def include_resource(resource)
          @serializer.relationships(self, resource) if @included_resources[resource.class].add?(resource)
        end

        def include_resources(resources)
          resources.each { |resource| include_resource(resource) }
        end
      end
    end
  end
end
