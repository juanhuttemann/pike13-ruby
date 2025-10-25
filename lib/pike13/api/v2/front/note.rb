# frozen_string_literal: true

module Pike13
  module API
    module V2
      module Front
        # Notes in Front API are nested under people
        # Use: person.notes or with custom uri
        class Note < Base
          uri "front/people/:person_id/notes(/:id)"
          include_root_in_json :note
        end
      end
    end
  end
end
