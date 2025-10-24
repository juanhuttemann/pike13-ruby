# frozen_string_literal: true

module Pike13
  module API
    module V2
      module Desk
        class EventOccurrence < Pike13::API::V2::Base
          @resource_name = "event_occurrences"

          # Nested resource methods using has_many DSL
          has_many :visits
          has_many :waitlist_entries

          # Get summary of event occurrences
          #
          # @param client [Pike13::Client] Client client
          # @param params [Hash] Query parameters (filters, etc.)
          # @return [Array<Hash>] Array of event occurrence summaries
          #
          # @example
          #   Pike13::API::V2::Desk::EventOccurrence.summary(client: client)
          def self.summary(client:, **params)
            path = "/#{scope}/#{resource_name}/summary"
            response = client.get(path, params: params)
            response["event_occurrence_summaries"] || []
          end

          # Get enrollment eligibilities for an event occurrence
          #
          # @param id [Integer] Event occurrence ID
          # @param client [Pike13::Client] Client client
          # @param params [Hash] Query parameters (filters, etc.)
          # @return [Array<Hash>] Array of enrollment eligibilities
          #
          # @example
          #   Pike13::API::V2::Desk::EventOccurrence.enrollment_eligibilities(id: 123, client: client)
          def self.enrollment_eligibilities(id:, client:, **params)
            path = "/#{scope}/#{resource_name}/#{id}/enrollment_eligibilities"
            response = client.get(path, params: params)
            response["enrollment_eligibilities"] || []
          end
        end
      end
    end
  end
end
