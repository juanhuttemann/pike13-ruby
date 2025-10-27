# frozen_string_literal: true

module Pike13
  module API
    module V2
      module Front
        class PersonWaiver < Base
          class << self
            # GET /front/people/:person_id/waivers
            def all(person_id:, **params)
              client.get("front/people/#{person_id}/waivers", params)
            end
          end
        end
      end
    end
  end
end
