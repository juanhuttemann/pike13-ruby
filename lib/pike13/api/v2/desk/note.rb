# frozen_string_literal: true

module Pike13
  module API
    module V2
      module Desk
        class Note < Base
          class << self
            # GET /desk/people/:person_id/notes
            def all(person_id:)
              client.get("desk/people/#{person_id}/notes")
            end

            # GET /desk/people/:person_id/notes/:id
            def find(person_id:, id:)
              client.get("desk/people/#{person_id}/notes/#{id}")
            end

            # POST /desk/people/:person_id/notes
            def create(person_id:, attributes:)
              client.post("desk/people/#{person_id}/notes", { note: attributes })
            end

            # PUT /desk/people/:person_id/notes/:id
            def update(person_id:, id:, attributes:)
              client.put("desk/people/#{person_id}/notes/#{id}", { note: attributes })
            end

            # DELETE /desk/people/:person_id/notes/:id
            def destroy(person_id:, id:)
              client.delete("desk/people/#{person_id}/notes/#{id}")
            end
          end
        end
      end
    end
  end
end
