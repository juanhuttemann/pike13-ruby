# frozen_string_literal: true

module Pike13
  module API
    module V2
      module Desk
        class EventOccurrence < Base
          uri "desk/event_occurrences(/:id)"
          include_root_in_json :event_occurrence

          # Associations
          has_many :visits, class_name: "Pike13::API::V2::Desk::Visit",
                            uri: "desk/event_occurrences/:event_occurrence_id/visits"
          has_many :waitlist_entries, class_name: "Pike13::API::V2::Desk::WaitlistEntry",
                                      uri: "desk/event_occurrences/:event_occurrence_id/waitlist_entries"

          class << self
            # Get summary of event occurrences
            # Returns raw hash data, not Spyke models
            def summary(**params)
              url = "/api/v2/desk/event_occurrences/summary"
              url += "?#{URI.encode_www_form(params)}" if params.any?
              response = connection.get(url)
              # API returns {"event_occurrence_summaries": [...]}, Pike13JSONParser extracts this as data array
              (response.body[:data] || []).map(&:deep_stringify_keys)
            end

            # Get enrollment eligibilities for an event occurrence
            # Returns raw hash data, not Spyke models
            def enrollment_eligibilities(id:, **params)
              url = "/api/v2/desk/event_occurrences/#{id}/enrollment_eligibilities"
              url += "?#{URI.encode_www_form(params)}" if params.any?
              response = connection.get(url)
              # API returns {"enrollment_eligibilities": [...]}, Pike13JSONParser extracts this as data array
              (response.body[:data] || []).map(&:deep_stringify_keys)
            end
          end
        end
      end
    end
  end
end
