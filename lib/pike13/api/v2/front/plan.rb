# frozen_string_literal: true

module Pike13
  module API
    module V2
      module Front
        class Plan < Base
          uri "front/plans(/:id)"
          include_root_in_json :plan

          def plan_terms
            self.class.with("front/plans/#{id}/plan_terms").to_a
          end
        end
      end
    end
  end
end
