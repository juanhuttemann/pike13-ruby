# frozen_string_literal: true

module Pike13
  module API
    module V2
      module Desk
        class Visit < Pike13::API::V2::Base
          @resource_name = "visits"

          # Override all to support person_id filter
          def self.all(client:, person_id: nil, **params)
            if person_id
              path = "/#{scope}/people/#{person_id}/visits"
              response = client.get(path, params: params)
              data = response[resource_name] || []
              data.map { |item| new(client: client, **item.transform_keys(&:to_sym)) }
            else
              super(client: client, **params)
            end
          end

          # Get visit summary for a person
          # Lists the first and last completed visit times for a person
          # Includes both overall first and last visits as well as per service
          #
          # @param person_id [Integer] Person ID
          # @param client [Pike13::Client] Client client
          # @return [Hash] Visit summary data with first/last visit timestamps
          #
          # @example
          #   Pike13::API::V2::Desk::Visit.summary(person_id: 123, client: client)
          #   # => { "first_visit_at" => "2020-01-01T00:00:00Z", "last_visit_at" => "2025-10-21T00:00:00Z", ... }
          def self.summary(person_id:, client:)
            path = "/#{scope}/people/#{person_id}/visits/summary"
            response = client.get(path)
            response["visit_summary"] || {}
          end
        end
      end
    end
  end
end
