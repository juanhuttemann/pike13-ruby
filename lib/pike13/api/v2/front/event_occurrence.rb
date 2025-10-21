# frozen_string_literal: true

module Pike13
  module API
    module V2
      module Front
        class EventOccurrence < Pike13::API::V2::Base
          @scope = "front"
          @resource_name = "event_occurrences"

          # Get summary of event occurrences
          #
          # @param session [Pike13::Client] Client session
          # @param params [Hash] Query parameters (filters, etc.)
          # @return [Array<Hash>] Array of event occurrence summaries
          #
          # @example
          #   Pike13::API::V2::Front::EventOccurrence.summary(session: client)
          def self.summary(session:, **params)
            path = "/#{scope}/#{resource_name}/summary"
            response = session.http_client.get(path, params: params, scoped: scoped?)
            response["event_occurrence_summaries"] || []
          end

          # Get enrollment eligibilities for an event occurrence
          #
          # @param id [Integer] Event occurrence ID
          # @param session [Pike13::Client] Client session
          # @param params [Hash] Query parameters (filters, etc.)
          # @return [Array<Hash>] Array of enrollment eligibilities
          #
          # @example
          #   Pike13::API::V2::Front::EventOccurrence.enrollment_eligibilities(id: 123, session: client)
          def self.enrollment_eligibilities(id:, session:, **params)
            path = "/#{scope}/#{resource_name}/#{id}/enrollment_eligibilities"
            response = session.http_client.get(path, params: params, scoped: scoped?)
            response["enrollment_eligibilities"] || []
          end
        end
      end
    end
  end
end
