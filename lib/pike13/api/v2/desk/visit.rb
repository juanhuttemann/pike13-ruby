# frozen_string_literal: true

module Pike13
  module API
    module V2
      module Desk
        class Visit < Base
          class << self
            # GET /desk/visits
            def all
              client.get("desk/visits")
            end

            # GET /desk/visits/:id
            def find(id)
              client.get("desk/visits/#{id}")
            end

            # GET /desk/people/:person_id/visits/summary
            def summary(person_id:, **params)
              client.get("desk/people/#{person_id}/visits/summary", params)
            end
          end
        end
      end
    end
  end
end
