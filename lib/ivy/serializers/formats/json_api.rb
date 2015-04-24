require 'ivy/serializers/formats/json'

module Ivy
  module Serializers
    module Formats
      class JSONAPI < JSON
        def attribute(key, value)
          value = coerce_id(value) if key == :id
          super
        end

        def linked(document)
          @hash_gen.store_object(:linked) { super }
        end

        def links(document)
          @hash_gen.store_object(:links) { super }
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
      end
    end
  end
end
