# frozen_string_literal: true

module Pike13
  module API
    module V2
      # Proxy class that wraps API resources and automatically injects client
      # Enables cleaner API: client.desk.people.find(123) instead of
      # Pike13::API::V2::Desk::Person.find(id: 123, client: client)
      #
      # @example Standard resource usage
      #   proxy = ResourceProxy.new(Pike13::API::V2::Desk::Person, client)
      #   proxy.find(123)         # => Person instance
      #   proxy.all(page: 1)      # => [Person, Person, ...]
      #   proxy.search("john")    # Forwards custom methods
      class ResourceProxy
        attr_reader :resource_class, :client

        # Initialize a resource proxy
        #
        # @param resource_class [Class] The resource class to proxy
        # @param client [Pike13::Client] The client instance
        def initialize(resource_class, client)
          raise ArgumentError, "resource_class is required" unless resource_class
          raise ArgumentError, "client is required" unless client

          @resource_class = resource_class
          @client = client
        end

        # Find a resource by ID or retrieve a singular resource
        #
        # @param id [Integer, nil] Resource ID (nil for singular resources)
        # @param params [Hash] Additional query parameters
        # @return [Base] Resource instance
        def find(id = nil, **params)
          if id
            @resource_class.find(id: id, client: @client, **params)
          else
            @resource_class.find(client: @client, **params)
          end
        end

        # Get all resources
        #
        # @param params [Hash] Query parameters (page, per_page, filters)
        # @return [Array<Base>] Array of resource instances
        def all(**params)
          @resource_class.all(client: @client, **params)
        end

        # Forward any other method calls to the resource class
        # Automatically injects the client parameter
        #
        # @example Custom methods
        #   proxy.search("john")  # Forwards to Person.search("john", client: client)
        #   proxy.me              # Forwards to Person.me(client: client)
        def method_missing(method, *args, **kwargs, &block)
          if @resource_class.respond_to?(method)
            @resource_class.public_send(method, *args, client: @client, **kwargs, &block)
          else
            super
          end
        end

        def respond_to_missing?(method, include_private = false)
          @resource_class.respond_to?(method) || super
        end
      end
    end
  end
end
