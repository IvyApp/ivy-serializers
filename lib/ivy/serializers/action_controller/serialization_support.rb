module Ivy
  module Serializers
    module ActionController
      module SerializationSupport
        extend ActiveSupport::Concern

        class SerializerNotFound < ::StandardError
        end

        included do
          class_attribute :serializer, :instance_writer => false
          class_attribute :serialization_format, :instance_writer => false
          self.serialization_format = Formats::ActiveModelSerializers
        end

        private

        %w[ _render_option_json _render_with_renderer_json ].each do |renderer_method|
          define_method(renderer_method) do |resource, options|
            unless serializer
              raise SerializerNotFound, "No serializer found in #{self.class.name}"
            end

            unless resource.kind_of?(::Hash)
              resource = Documents.create(serializer, controller_name, resource)
              resource = serialization_format.new(resource)
            end

            super(resource, options)
          end
        end
      end
    end
  end
end
