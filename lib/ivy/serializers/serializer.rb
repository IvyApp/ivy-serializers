module Ivy
  module Serializers
    class Attribute
      def initialize(name)
        @name = name
      end

      def generate(generator, resource)
        generator.attribute(@name, resource.public_send(@name))
      end
    end

    class Relationship
      def initialize(name, options={})
        @name = name
        @options = options
      end

      def get(resource)
        resource.public_send(@name)
      end
    end

    class BelongsTo < Relationship
      def generate(generator, resource)
        generator.belongs_to(@name, get(resource), @options)
      end
    end

    class HasMany < Relationship
      def generate(generator, resource)
        generator.has_many(@name, get(resource), @options)
      end
    end

    class Mapping
      def initialize(klass)
        @attrs = {}
        @links = {}
        @klass = klass

        attribute(:id)
      end

      def attribute(name)
        @attrs[name] = Attribute.new(name)
      end

      def attributes(*names)
        names.each { |name| attribute(name) }
      end

      def belongs_to(name, options={})
        @links[name] = BelongsTo.new(name, options)
      end

      def has_many(name, options={})
        @links[name] = HasMany.new(name, options)
      end

      def links(generator, resource)
        @links.each_value { |link| link.generate(generator, resource) }
      end

      def resource(generator, resource)
        @attrs.each_value { |attr| attr.generate(generator, resource) }
      end
    end

    class Registry
      def initialize
        @mappings = Hash.new { |hash, klass| hash[klass] = new_mapping(klass) }
      end

      def links(generator, resource)
        mapping_for(resource.class).links(generator, resource)
      end

      def map(klass, &block)
        mapping_for(klass).instance_eval(&block)
      end

      def mapping_for(klass)
        @mappings[klass]
      end

      def resource(generator, resource)
        mapping_for(resource.class).resource(generator, resource)
      end

      private

      def new_mapping(klass)
        Mapping.new(klass)
      end
    end

    class Serializer
      class << self
        attr_accessor :_registry

        def inherited(base)
          base._registry = Registry.new
        end

        def links(generator, resource)
          _registry.links(generator, resource)
        end

        def map(klass, &block)
          _registry.map(klass, &block)
        end

        def resource(generator, resource)
          _registry.resource(generator, resource)
        end
      end
    end
  end
end
