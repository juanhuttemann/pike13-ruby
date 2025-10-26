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

          def self.summary(**params)
            with("desk/event_occurrences/summary").where(params).to_a
          end

          def self.enrollment_eligibilities(id:, **params)
            with("desk/event_occurrences/#{id}/enrollment_eligibilities").where(params).to_a
          end
        end
      end
    end
  end
end
