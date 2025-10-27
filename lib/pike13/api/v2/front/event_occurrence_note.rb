# frozen_string_literal: true

module Pike13
  module API
    module V2
      module Front
        class EventOccurrenceNote < Base
          class << self
            # GET /front/event_occurrences/:event_occurrence_id/notes
            def all(event_occurrence_id:, **params)
              client.get("front/event_occurrences/#{event_occurrence_id}/notes", params)
            end

            # GET /front/event_occurrences/:event_occurrence_id/notes/:id
            def find(event_occurrence_id:, id:)
              client.get("front/event_occurrences/#{event_occurrence_id}/notes/#{id}")
            end
          end
        end
      end
    end
  end
end
