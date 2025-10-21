# frozen_string_literal: true

module Pike13
  module API
    module V2
      class Base
        attr_reader :session, :attributes

        class << self
          attr_accessor :scope, :resource_name

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
              response = session.http_client.get(path, params: params, scoped: self.class.scoped?)
              response[resource_name.to_s] || []
            end
          end
          # rubocop:enable Naming/PredicatePrefix
        end

        def initialize(session:, **attributes)
          @session = session
          @attributes = attributes
          attributes.each do |key, value|
            instance_variable_set("@#{key}", value)
            self.class.attr_reader(key) unless respond_to?(key)
          end
        end

        def self.find(id:, session:, **params)
          path = "/#{scope}/#{resource_name}/#{id}"
          response = session.http_client.get(path, params: params, scoped: scoped?)
          data = response[resource_name]&.first || {}
          new(session: session, **data.transform_keys(&:to_sym))
        end

        def self.all(session:, **params)
          path = "/#{scope}/#{resource_name}"
          response = session.http_client.get(path, params: params, scoped: scoped?)
          data = response[resource_name] || []
          data.map { |item| new(session: session, **item.transform_keys(&:to_sym)) }
        end

        # Get total count of resources
        # Uses per_page: 1 to minimize data transfer
        #
        # @param session [Pike13::Client] Client session
        # @param params [Hash] Query parameters (filters, etc.)
        # @return [Integer] Total count from API
        #
        # @example
        #   Pike13::API::V2::Desk::Person.count(session: client)
        #   # => 56
        def self.count(session:, **params)
          path = "/#{scope}/#{resource_name}"
          # Request minimal data, we only need total_count from pagination
          response = session.http_client.get(path, params: params.merge(per_page: 1), scoped: scoped?)
          response["total_count"] || 0
        end

        def self.scoped?
          scope != "account"
        end

        def id
          @id || attributes[:id]
        end

        def reload
          reloaded = self.class.find(id: id, session: session)
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

        private

        def inspect_attributes
          attributes.map { |k, v| "@#{k}=#{v.inspect}" }.join(", ")
        end
      end
    end
  end
end
