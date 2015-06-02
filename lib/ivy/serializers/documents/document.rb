require 'set'

module Ivy
  module Serializers
    module Documents
      class Document
        def initialize(serializer, primary_resource_name, primary_resource)
          @serializer = serializer
          @primary_resource_name = primary_resource_name
          @primary_resource = primary_resource
          @linked_resources = Hash.new { |hash, klass| hash[klass] = Set.new }
        end

        def belongs_to(name, resource, options={})
          link(resource) if options[:embed_in_root]
        end

        def generate(generator)
          generator.document(self)
        end

        def generate_attributes(generator, resource)
          @serializer.attributes(generator, resource)
        end

        def generate_linked(generator)
          generator.linked(self) unless @linked_resources.empty?
        end

        def generate_linked_resources(generator)
          @linked_resources.each_pair { |klass, resources| generator.linked_resources(klass, resources) }
        end

        def generate_relationships(generator, resource)
          @serializer.relationships(generator, resource)
        end

        def generate_resource(generator, resource)
          @serializer.resource(generator, resource)
        end

        def has_many(name, resources, options={})
          link_many(resources) if options[:embed_in_root]
        end

        private

        def link(resource)
          @serializer.relationships(self, resource) if @linked_resources[resource.class].add?(resource)
        end

        def link_many(resources)
          resources.each { |resource| link(resource) }
        end
      end
    end
  end
end
