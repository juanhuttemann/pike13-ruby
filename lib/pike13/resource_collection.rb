# frozen_string_literal: true

module Pike13
  # Base class for resource collections (Account, Desk, Front)
  # Automatically creates accessor methods for registered resources
  #
  # @example Define a resource collection
  #   class MyResources < ResourceCollection
  #     register_resources(
  #       people: API::V2::Desk::Person,
  #       events: API::V2::Desk::Event
  #     )
  #   end
  class ResourceCollection
    def initialize(client)
      @client = client
    end

    class << self
      # Register resources and create accessor methods
      #
      # @param resources [Hash] Hash of method_name => resource_class
      def register_resources(resources)
        @resources = resources.freeze

        resources.each do |method_name, resource_class|
          define_method(method_name) do
            resource_class
          end
        end
      end

      # Get all registered resources
      #
      # @return [Hash] Hash of registered resources
      def resources
        @resources || {}
      end
    end
  end
end
