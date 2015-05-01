require 'ivy/serializers/action_controller/serialization_support'

module Ivy
  module Serializers
    class Railtie < ::Rails::Railtie
      initializer 'ivy.serializers.controllers' do
        ActiveSupport.on_load(:action_controller) do
          include ::Ivy::Serializers::ActionController::SerializationSupport
        end
      end
    end
  end
end
