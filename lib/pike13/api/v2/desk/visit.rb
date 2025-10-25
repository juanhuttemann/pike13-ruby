# frozen_string_literal: true

module Pike13
  module API
    module V2
      module Desk
        class Visit < Spyke::Base
          uri "desk/visits(/:id)"
          include_root_in_json :visit

          class << self
            def summary(person_id:, client:, **params)
              response = client.get("/desk/people/#{person_id}/visits/summary", params: params)
              response["visit_summary"] || {}
            end
          end
        end
      end
    end
  end
end
