require 'ivy/serializers/formats/json'

module Ivy
  module Serializers
    module Formats
      class JSONAPI < JSON
        def attribute(key, value)
          value = coerce_id(value) if key == :id
          super
        end

        def belongs_to(name, resource, options={})
          @hash_gen.store_object(name) { linkage(resource) }
        end

        def has_many(name, resources, options={})
          @hash_gen.store_object(name) { linkages(resources) }
        end

        def linked(document)
          @hash_gen.store_object(:included) { super }
        end

        def links(document)
          @hash_gen.store_object(:links) { super }
        end

        def primary_resource(primary_resource_name, primary_resource)
          super(:data, primary_resource)
        end

        def primary_resources(primary_resources_name, primary_resources)
          super(:data, primary_resources)
        end

        def resource(resource)
          super
          type(:type, resource)
        end

        private

        def coerce_id(id)
          id.to_s
        end

        def extract_id(resource)
          coerce_id(super)
        end

        def linkage(resource)
          @hash_gen.store_object(:linkage) { linkage_object(resource) }
        end

        def linkage_object(resource)
          id(:id, resource)
          type(:type, resource)
        end

        def linkages(resources)
          @hash_gen.store_array(:linkage) { linkage_objects(resources) }
        end

        def linkage_objects(resources)
          resources.each { |resource| @hash_gen.push_object { linkage_object(resource) } }
        end
      end
    end
  end
end
