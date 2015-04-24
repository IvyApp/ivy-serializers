require 'ivy/serializers/formats/json'

module Ivy
  module Serializers
    module Formats
      class ActiveModelSerializers < JSON
        def belongs_to(name, resource, options={})
          if options[:polymorphic]
            if resource
              @hash_gen.store_object(name) { polymorphic_resource(resource) }
            else
              @hash_gen.store(name, nil)
            end
          else
            id(:"#{name}_id", resource)
          end
        end

        def has_many(name, resources, options={})
          if options[:polymorphic]
            @hash_gen.store_array(name) { polymorphic_resources(resources) }
          else
            ids(:"#{ActiveSupport::Inflector.singularize(name.to_s)}_ids", resources)
          end
        end

        private

        def polymorphic_resource(resource)
          id(:id, resource)
          type(:type, resource)
        end

        def polymorphic_resources(resources)
          resources.each { |resource| @hash_gen.push_object { polymorphic_resource(resource) } }
        end
      end
    end
  end
end
