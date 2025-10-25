# frozen_string_literal: true

module Pike13
  module API
    module V2
      module Desk
        class EventOccurrence < Spyke::Base
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
            def summary(client:, **params)
              response = client.get("/desk/event_occurrences/summary", params: params)
              response["event_occurrence_summaries"] || []
            end

            # Get enrollment eligibilities for an event occurrence
            # Returns raw hash data, not Spyke models
            def enrollment_eligibilities(id:, client:, **params)
              response = client.get("/desk/event_occurrences/#{id}/enrollment_eligibilities", params: params)
              response["enrollment_eligibilities"] || []
            end
          end
        end
      end
    end
  end
end
