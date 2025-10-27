# frozen_string_literal: true

module Pike13
  module API
    module V2
      module Desk
        class EventOccurrenceNote < Base
          class << self
            # GET /desk/event_occurrences/:event_occurrence_id/notes
            def all(event_occurrence_id:, **params)
              client.get("desk/event_occurrences/#{event_occurrence_id}/notes", params)
            end

            # GET /desk/event_occurrences/:event_occurrence_id/notes/:id
            def find(event_occurrence_id:, id:)
              client.get("desk/event_occurrences/#{event_occurrence_id}/notes/#{id}")
            end

            # POST /desk/event_occurrences/:event_occurrence_id/notes
            def create(event_occurrence_id:, attributes:)
              client.post("desk/event_occurrences/#{event_occurrence_id}/notes", { note: attributes })
            end

            # PUT /desk/event_occurrences/:event_occurrence_id/notes/:id
            def update(event_occurrence_id:, id:, attributes:)
              client.put("desk/event_occurrences/#{event_occurrence_id}/notes/#{id}", { note: attributes })
            end

            # DELETE /desk/event_occurrences/:event_occurrence_id/notes/:id
            def destroy(event_occurrence_id:, id:)
              client.delete("desk/event_occurrences/#{event_occurrence_id}/notes/#{id}")
            end
          end
        end
      end
    end
  end
end
