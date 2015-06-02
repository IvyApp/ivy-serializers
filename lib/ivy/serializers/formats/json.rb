require 'active_support/inflector'
require 'hash_generator'

module Ivy
  module Serializers
    module Formats
      class JSON
        def initialize(document)
          @document = document
          @hash_gen = HashGenerator.new
        end

        def as_json(*)
          @document.generate(self)
          @hash_gen.to_h
        end

        def attribute(key, value)
          @hash_gen.store(key, value)
        end

        def attributes(resource)
          @document.generate_attributes(self, resource)
        end

        def belongs_to(name, resource, options={})
          id(name, resource)
        end

        def document(document)
          document.generate_primary_resource(self)
          document.generate_linked(self)
        end

        def has_many(name, resources, options={})
          ids(name, resources)
        end

        def id(key, resource)
          attribute(key, extract_id(resource))
        end

        def ids(key, resources)
          attribute(key, resources.map { |resource| extract_id(resource) })
        end

        def linked(document)
          document.generate_linked_resources(self)
        end

        def linked_resources(resource_class, resources)
          key = key_for_collection(resource_class).to_sym
          @hash_gen.store_array(key) { resources(resources) }
        end

        def primary_resource(primary_resource_name, primary_resource)
          @hash_gen.store_object(primary_resource_name) { resource(primary_resource) }
        end

        def primary_resources(primary_resources_name, primary_resources)
          @hash_gen.store_array(primary_resources_name) { resources(primary_resources) }
        end

        def relationships(resource)
          @document.generate_relationships(self, resource)
        end

        def resource(resource)
          id(:id, resource)
          @document.generate_resource(self, resource)
        end

        def resources(resources)
          resources.each { |resource| @hash_gen.push_object { resource(resource) } }
        end

        def type(key, resource)
          attribute(key, extract_type(resource))
        end

        private

        def extract_id(resource)
          resource.id
        end

        def extract_type(resource)
          ActiveSupport::Inflector.dasherize(key_for_individual(resource.class))
        end

        def key_for_collection(resource_class)
          ActiveSupport::Inflector.pluralize(key_for_individual(resource_class))
        end

        def key_for_individual(resource_class)
          ActiveSupport::Inflector.underscore(resource_class.name)
        end
      end
    end
  end
end
