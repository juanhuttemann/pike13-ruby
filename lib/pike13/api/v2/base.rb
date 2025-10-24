# frozen_string_literal: true

module Pike13
  module API
    module V2
      class Base
        include Attributes
        include Serialization

        # Minimum per_page value for count queries to minimize data transfer
        COUNT_PER_PAGE = 1

        attr_reader :client

        class << self
          attr_accessor :resource_name

          # Automatically infer scope from module namespace
          # Pike13::API::V2::Desk::Person => "desk"
          # Pike13::API::V2::Account::Business => "account"
          # Pike13::API::V2::Front::Event => "front"
          def scope
            @scope ||= begin
              # Get the namespace module (e.g., Desk, Account, Front)
              namespace = name.split("::")[-2]
              namespace&.downcase
            end
          end

          # DSL for declaring nested resources (has_many relationships)
          # Automatically generates methods to fetch related resources
          #
          # @param resource_name [Symbol] The name of the nested resource
          #
          # @example
          #   class Person < Base
          #     has_many :visits
          #     has_many :plans
          #   end
          #
          #   person.visits  # => [Visit, Visit, ...]
          #   person.visits(from: Time.now - 30.days, to: Time.now)  # => [Visit, Visit, ...]
          #   person.plans(include_holds: true, filter: 'active')  # => [Plan, Plan, ...]
          def define_association(resource_name)
            define_method(resource_name) do |**params|
              path = "/#{self.class.scope}/#{self.class.resource_name}/#{id}/#{resource_name}"
              response = client.get(path, params: params)
              response[resource_name.to_s] || []
            end
          end
          alias has_many define_association
        end

        def initialize(client:, **attributes)
          raise ArgumentError, "client is required" unless client

          @client = client
          initialize_attributes(**attributes)
        end

        # Find a resource by ID
        #
        # @param id [Integer, String] The resource ID
        # @param client [Pike13::Client] Client instance
        # @param params [Hash] Additional query parameters
        # @return [Base] Instance of the resource
        # @raise [ArgumentError] if id or client is missing
        def self.find(id:, client:, **params)
          raise ArgumentError, "id is required" if id.nil? || id.to_s.empty?
          raise ArgumentError, "client is required" unless client

          path = "/#{scope}/#{resource_name}/#{id}"
          response = client.get(path, params: params)
          data = response[resource_name]&.first || {}
          new(client: client, **data.transform_keys(&:to_sym))
        end

        # Get all resources with optional filtering
        #
        # @param client [Pike13::Client] Client instance
        # @param params [Hash] Query parameters (page, per_page, filters, etc.)
        # @return [Array<Base>] Array of resource instances
        # @raise [ArgumentError] if client is missing
        def self.all(client:, **params)
          raise ArgumentError, "client is required" unless client

          path = "/#{scope}/#{resource_name}"
          response = client.get(path, params: params)
          data = response[resource_name] || []
          data.map { |item| new(client: client, **item.transform_keys(&:to_sym)) }
        end

        # Get total count of resources
        # Uses minimal per_page value to reduce data transfer
        #
        # @param client [Pike13::Client] Client instance
        # @param params [Hash] Query parameters (filters, etc.)
        # @return [Integer] Total count from API
        # @raise [ArgumentError] if client is missing
        #
        # @example
        #   Pike13::API::V2::Desk::Person.count(client: client)
        #   # => 56
        def self.count(client:, **params)
          raise ArgumentError, "client is required" unless client

          path = "/#{scope}/#{resource_name}"
          # Request minimal data, we only need total_count from pagination
          response = client.get(path, params: params.merge(per_page: COUNT_PER_PAGE))
          response["total_count"] || 0
        end

        # Reload the resource from the API
        # Refreshes all attributes with latest data from server
        #
        # @return [self] The reloaded resource
        def reload
          reloaded = self.class.find(id: id, client: client)
          @attributes = reloaded.attributes
          reloaded.attributes.each do |key, value|
            instance_variable_set("@#{key}", value)
          end
          self
        end
      end
    end
  end
end
