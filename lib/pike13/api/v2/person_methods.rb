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
          # @param session [Pike13::Client] Client session
          # @return [Person] The authenticated person
          #
          # @example
          #   me = Pike13::API::V2::Desk::Person.me(session: client)
          def me(session:)
            path = "/#{scope}/#{resource_name}/me"
            response = session.http_client.get(path, scoped: scoped?)

            data = response[resource_name]&.first || {}
            new(session: session, **data.transform_keys(&:to_sym))
          end

          # Search for people by query string
          #
          # @param query [String] Search query
          # @param session [Pike13::Client] Client session
          # @param params [Hash] Additional query parameters
          # @return [Array<Person>] Array of matching people
          #
          # @example
          #   results = Pike13::API::V2::Desk::Person.search("john", session: client)
          def search(query, session:, **params)
            path = "/#{scope}/#{resource_name}/search"
            response = session.http_client.get(path, params: params.merge(q: query), scoped: scoped?)

            data = response[resource_name] || []
            data.map { |item| new(session: session, **item.transform_keys(&:to_sym)) }
          end
        end
      end
    end
  end
end
