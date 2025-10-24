# frozen_string_literal: true

module Pike13
  module API
    module V2
      # Shared methods for Person resources across different API scopes.
      # Provides common functionality like me() and search() endpoints.
      module PersonMethods
        def self.included(base)
          base.extend(ClassMethods)
        end

        module ClassMethods
          # Get the currently authenticated person
          #
          # @param client [Pike13::Client] Client client
          # @return [Person] The authenticated person
          #
          # @example
          #   me = Pike13::API::V2::Desk::Person.me(client: client)
          def me(client:)
            path = "/#{scope}/#{resource_name}/me"
            response = client.get(path)

            data = response[resource_name]&.first || {}
            new(client: client, **data.transform_keys(&:to_sym))
          end

          # Search for people by query string
          #
          # @param query [String] Search query
          # @param client [Pike13::Client] Client client
          # @param params [Hash] Additional query parameters
          # @return [Array<Person>] Array of matching people
          #
          # @example
          #   results = Pike13::API::V2::Desk::Person.search("john", client: client)
          def search(query, client:, **params)
            path = "/#{scope}/#{resource_name}/search"
            response = client.get(path, params: params.merge(q: query))

            data = response[resource_name] || []
            data.map { |item| new(client: client, **item.transform_keys(&:to_sym)) }
          end
        end
      end
    end
  end
end
