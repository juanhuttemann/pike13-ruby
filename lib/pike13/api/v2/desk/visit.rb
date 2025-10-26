# frozen_string_literal: true

module Pike13
  module API
    module V2
      module Desk
        class Visit < Base
          uri "desk/visits(/:id)"
          include_root_in_json :visit

          def self.summary(person_id:, **params)
            with("desk/people/#{person_id}/visits/summary").where(params).first.attributes.to_h
          end
        end
      end
    end
  end
end
