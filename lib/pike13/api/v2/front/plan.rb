# frozen_string_literal: true

module Pike13
  module API
    module V2
      module Front
        class Plan < Spyke::Base
          uri "front/plans(/:id)"
          include_root_in_json :plan

          def plan_terms
            result = self.class.request(:get, "front/plans/#{id}/plan_terms")
            result.data || []
          end
        end
      end
    end
  end
end
