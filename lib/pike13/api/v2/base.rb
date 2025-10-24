# frozen_string_literal: true

module Pike13
  module API
    module V2
      class Base
        attr_reader :client, :attributes

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
          # rubocop:disable Naming/PredicatePrefix
          def has_many(resource_name)
            define_method(resource_name) do |**params|
              path = "/#{self.class.scope}/#{self.class.resource_name}/#{id}/#{resource_name}"
              response = client.get(path, params: params)
              response[resource_name.to_s] || []
            end
          end
          # rubocop:enable Naming/PredicatePrefix
        end

        def initialize(client:, **attributes)
          @client = client
          @attributes = attributes
          attributes.each do |key, value|
            instance_variable_set("@#{key}", value)
            self.class.attr_reader(key) unless respond_to?(key)
          end
        end

        def self.find(id:, client:, **params)
          path = "/#{scope}/#{resource_name}/#{id}"
          response = client.get(path, params: params)
          data = response[resource_name]&.first || {}
          new(client: client, **data.transform_keys(&:to_sym))
        end

        def self.all(client:, **params)
          path = "/#{scope}/#{resource_name}"
          response = client.get(path, params: params)
          data = response[resource_name] || []
          data.map { |item| new(client: client, **item.transform_keys(&:to_sym)) }
        end

        # Get total count of resources
        # Uses per_page: 1 to minimize data transfer
        #
        # @param client [Pike13::Client] Client instance
        # @param params [Hash] Query parameters (filters, etc.)
        # @return [Integer] Total count from API
        #
        # @example
        #   Pike13::API::V2::Desk::Person.count(client: client)
        #   # => 56
        def self.count(client:, **params)
          path = "/#{scope}/#{resource_name}"
          # Request minimal data, we only need total_count from pagination
          response = client.get(path, params: params.merge(per_page: 1))
          response["total_count"] || 0
        end

        def id
          @id || attributes[:id]
        end

        def reload
          reloaded = self.class.find(id: id, client: client)
          @attributes = reloaded.attributes
          reloaded.attributes.each do |key, value|
            instance_variable_set("@#{key}", value)
          end
          self
        end

        def inspect
          "#<#{self.class.name}:0x#{object_id.to_s(16)} #{inspect_attributes}>"
        end

        def to_s
          inspect
        end

        def to_json(*args)
          attributes.transform_keys(&:to_s).to_json(*args)
        end

        def as_json(_options = nil)
          attributes.transform_keys(&:to_s)
        end

        private

        def inspect_attributes
          attributes.map { |k, v| "@#{k}=#{v.inspect}" }.join(", ")
        end
      end
    end
  end
end
