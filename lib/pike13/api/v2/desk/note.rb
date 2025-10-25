# frozen_string_literal: true

module Pike13
  module API
    module V2
      module Desk
        class Note < Spyke::Base
          uri "desk/people/:person_id/notes(/:id)"
          include_root_in_json :note
        end
      end
    end
  end
end
