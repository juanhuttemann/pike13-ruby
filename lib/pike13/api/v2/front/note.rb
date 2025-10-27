# frozen_string_literal: true

module Pike13
  module API
    module V2
      module Front
        # Notes in Front API are nested under people
        class Note < Base
          class << self
            # GET /front/people/:person_id/notes
            def all(person_id:)
              client.get("front/people/#{person_id}/notes")
            end

            # GET /front/people/:person_id/notes/:id
            def find(person_id:, id:)
              client.get("front/people/#{person_id}/notes/#{id}")
            end
          end
        end
      end
    end
  end
end
