# frozen_string_literal: true

module Pike13
  module API
    module V2
      module Desk
        class EventOccurrenceWaitlistEntry < Base
          class << self
            # GET /desk/event_occurrences/:event_occurrence_id/waitlist_entries
            def all(event_occurrence_id:, **params)
              client.get("desk/event_occurrences/#{event_occurrence_id}/waitlist_entries", params)
            end
          end
        end
      end
    end
  end
end
