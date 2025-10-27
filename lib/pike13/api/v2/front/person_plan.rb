# frozen_string_literal: true

module Pike13
  module API
    module V2
      module Front
        class PersonPlan < Base
          class << self
            # GET /front/people/:person_id/plans
            def all(person_id:, **params)
              client.get("front/people/#{person_id}/plans", params)
            end
          end
        end
      end
    end
  end
end
