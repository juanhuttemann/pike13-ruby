# frozen_string_literal: true

module Pike13
  module API
    module V2
      module Front
        class PersonVisit < Base
          class << self
            # GET /front/people/:person_id/visits
            def all(person_id:, **params)
              client.get("front/people/#{person_id}/visits", params)
            end
          end
        end
      end
    end
  end
end
