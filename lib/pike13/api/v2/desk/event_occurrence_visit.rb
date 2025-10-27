# frozen_string_literal: true

module Pike13
  module API
    module V2
      module Desk
        class EventOccurrenceVisit < Base
          class << self
            # GET /desk/event_occurrences/:event_occurrence_id/visits
            def all(event_occurrence_id:, **params)
              client.get("desk/event_occurrences/#{event_occurrence_id}/visits", params)
            end
          end
        end
      end
    end
  end
end
