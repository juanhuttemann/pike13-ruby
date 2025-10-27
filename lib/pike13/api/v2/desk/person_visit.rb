# frozen_string_literal: true

module Pike13
  module API
    module V2
      module Desk
        class PersonVisit < Base
          class << self
            # GET /desk/people/:person_id/visits
            def all(person_id:, **params)
              client.get("desk/people/#{person_id}/visits", params)
            end
          end
        end
      end
    end
  end
end
