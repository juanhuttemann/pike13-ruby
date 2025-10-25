# frozen_string_literal: true

module Pike13
  module API
    module V2
      module Desk
        class Note < Pike13::API::V2::Base
          @resource_name = "notes"

          # Override find to support nested routes
          # Notes are always nested under people or event_occurrences
          #
          # @param id [Integer] The note ID
          # @param client [Pike13::Client] Client instance
          # @param person_id [Integer, nil] The person ID
          # @param event_occurrence_id [Integer, nil] The event occurrence ID
          # @param params [Hash] Additional query parameters
          # @return [Note] Note instance
          def self.find(id:, client:, person_id: nil, event_occurrence_id: nil, **params)
            raise ArgumentError, "person_id or event_occurrence_id is required" unless person_id || event_occurrence_id

            parent_path = person_id ? "people/#{person_id}" : "event_occurrences/#{event_occurrence_id}"
            path = "/#{scope}/#{parent_path}/#{resource_name}/#{id}"
            response = client.get(path, params: params)
            data = response[resource_name]&.first || {}
            new(client: client, **data.transform_keys(&:to_sym))
          end

          # Override all to support nested routes
          #
          # @param client [Pike13::Client] Client instance
          # @param person_id [Integer, nil] The person ID
          # @param event_occurrence_id [Integer, nil] The event occurrence ID
          # @param params [Hash] Query parameters
          # @return [Array<Note>] Array of note instances
          def self.all(client:, person_id: nil, event_occurrence_id: nil, **params)
            raise ArgumentError, "person_id or event_occurrence_id is required" unless person_id || event_occurrence_id

            parent_path = person_id ? "people/#{person_id}" : "event_occurrences/#{event_occurrence_id}"
            path = "/#{scope}/#{parent_path}/#{resource_name}"
            response = client.get(path, params: params)
            data = response[resource_name] || []
            data.map { |item| new(client: client, **item.transform_keys(&:to_sym)) }
          end

          # Override create to support nested routes
          #
          # @param client [Pike13::Client] Client instance
          # @param person_id [Integer, nil] The person ID
          # @param event_occurrence_id [Integer, nil] The event occurrence ID
          # @param attributes [Hash] Note attributes
          # @return [Note] Newly created note instance
          def self.create(client:, person_id: nil, event_occurrence_id: nil, **attributes)
            raise ArgumentError, "person_id or event_occurrence_id is required" unless person_id || event_occurrence_id

            parent_path = person_id ? "people/#{person_id}" : "event_occurrences/#{event_occurrence_id}"
            path = "/#{scope}/#{parent_path}/#{resource_name}"
            body = { "note" => attributes }
            response = client.post(path, body: body)
            data = response[resource_name]&.first || {}
            new(client: client, **data.transform_keys(&:to_sym))
          end

          # Override update to support nested routes
          #
          # @param id [Integer] The note ID
          # @param client [Pike13::Client] Client instance
          # @param person_id [Integer, nil] The person ID
          # @param event_occurrence_id [Integer, nil] The event occurrence ID
          # @param attributes [Hash] Attributes to update
          # @return [Note] Updated note instance
          def self.update(id:, client:, person_id: nil, event_occurrence_id: nil, **attributes)
            raise ArgumentError, "person_id or event_occurrence_id is required" unless person_id || event_occurrence_id

            parent_path = person_id ? "people/#{person_id}" : "event_occurrences/#{event_occurrence_id}"
            path = "/#{scope}/#{parent_path}/#{resource_name}/#{id}"
            body = { "note" => attributes }
            response = client.put(path, body: body)
            data = response[resource_name]&.first || {}
            new(client: client, **data.transform_keys(&:to_sym))
          end

          # Override destroy to support nested routes
          #
          # @param id [Integer] The note ID
          # @param client [Pike13::Client] Client instance
          # @param person_id [Integer, nil] The person ID
          # @param event_occurrence_id [Integer, nil] The event occurrence ID
          # @return [Boolean] true if successful
          def self.destroy(id:, client:, person_id: nil, event_occurrence_id: nil)
            raise ArgumentError, "person_id or event_occurrence_id is required" unless person_id || event_occurrence_id

            parent_path = person_id ? "people/#{person_id}" : "event_occurrences/#{event_occurrence_id}"
            path = "/#{scope}/#{parent_path}/#{resource_name}/#{id}"
            client.delete(path)
            true
          end

          # Override instance update to preserve parent context
          def update(**attributes)
            updated = self.class.update(
              id: id,
              client: client,
              person_id: respond_to?(:person_id) ? person_id : nil,
              event_occurrence_id: respond_to?(:event_occurrence_id) ? event_occurrence_id : nil,
              **attributes
            )
            @attributes = updated.attributes
            updated.attributes.each do |key, value|
              instance_variable_set("@#{key}", value)
            end
            self
          end

          # Override instance destroy to preserve parent context
          def destroy
            self.class.destroy(
              id: id,
              client: client,
              person_id: respond_to?(:person_id) ? person_id : nil,
              event_occurrence_id: respond_to?(:event_occurrence_id) ? event_occurrence_id : nil
            )
          end
        end
      end
    end
  end
end
