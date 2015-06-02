require 'ivy/serializers/mapping'

module Ivy
  module Serializers
    class Registry
      def initialize
        @mappings = Hash.new { |hash, klass| hash[klass] = new_mapping(klass) }
      end

      def attributes(generator, resource)
        mapping_for(resource.class).generate_attributes(generator, resource)
      end

      def links(generator, resource)
        mapping_for(resource.class).links(generator, resource)
      end

      def map(klass, &block)
        mapping_for(klass).instance_eval(&block)
      end

      def resource(generator, resource)
        mapping_for(resource.class).resource(generator, resource)
      end

      private

      def mapping_for(klass)
        @mappings[klass]
      end

      def new_mapping(klass)
        Mapping.new(klass)
      end
    end
  end
end
