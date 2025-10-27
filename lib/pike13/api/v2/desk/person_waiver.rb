# frozen_string_literal: true

module Pike13
  module API
    module V2
      module Desk
        class PersonWaiver < Base
          class << self
            # GET /desk/people/:person_id/waivers
            def all(person_id:, **params)
              client.get("desk/people/#{person_id}/waivers", params)
            end
          end
        end
      end
    end
  end
end
