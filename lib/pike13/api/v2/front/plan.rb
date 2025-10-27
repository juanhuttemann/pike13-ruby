# frozen_string_literal: true

module Pike13
  module API
    module V2
      module Front
        class Plan < Base
          class << self
            # GET /front/plans
            def all
              client.get("front/plans")
            end

            # GET /front/plans/:id
            def find(id)
              client.get("front/plans/#{id}")
            end

            # GET /front/plans/:id/plan_terms
            def plan_terms(id)
              client.get("front/plans/#{id}/plan_terms")
            end
          end
        end
      end
    end
  end
end
