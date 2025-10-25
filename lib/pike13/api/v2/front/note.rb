# frozen_string_literal: true

module Pike13
  module API
    module V2
      module Front
        class Note < Pike13::API::V2::Base
          @resource_name = "notes"

          # Override find to support nested routes
          # Notes are nested under people in Front API
          #
          # @param id [Integer] The note ID
          # @param client [Pike13::Client] Client instance
          # @param person_id [Integer] The person ID
          # @param params [Hash] Additional query parameters
          # @return [Note] Note instance
          def self.find(id:, client:, person_id:, **params)
            path = "/#{scope}/people/#{person_id}/#{resource_name}/#{id}"
            response = client.get(path, params: params)
            data = response[resource_name]&.first || {}
            new(client: client, **data.transform_keys(&:to_sym))
          end

          # Override all to support nested routes
          #
          # @param client [Pike13::Client] Client instance
          # @param person_id [Integer] The person ID
          # @param params [Hash] Query parameters
          # @return [Array<Note>] Array of note instances
          def self.all(client:, person_id:, **params)
            path = "/#{scope}/people/#{person_id}/#{resource_name}"
            response = client.get(path, params: params)
            data = response[resource_name] || []
            data.map { |item| new(client: client, **item.transform_keys(&:to_sym)) }
          end
        end
      end
    end
  end
end
