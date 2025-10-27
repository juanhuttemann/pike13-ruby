# frozen_string_literal: true

module Pike13
  module API
    module V2
      module Front
        class EventOccurrenceWaitlistEligibility < Base
          class << self
            # GET /front/event_occurrences/:event_occurrence_id/waitlist_eligibilities
            def all(event_occurrence_id:, **params)
              client.get("front/event_occurrences/#{event_occurrence_id}/waitlist_eligibilities", params)
            end
          end
        end
      end
    end
  end
end
