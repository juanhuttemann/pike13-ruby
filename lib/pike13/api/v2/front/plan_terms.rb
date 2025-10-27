# frozen_string_literal: true

module Pike13
  module API
    module V2
      module Front
        class PlanTerms < Base
          class << self
            # GET /front/plans/:plan_id/plan_terms
            def all(plan_id:, **params)
              client.get("front/plans/#{plan_id}/plan_terms", params)
            end

            # GET /front/plans/:plan_id/plan_terms/:plan_terms_id
            def find(plan_id:, plan_terms_id:)
              client.get("front/plans/#{plan_id}/plan_terms/#{plan_terms_id}")
            end

            # GET /front/plans/:plan_id/plan_terms/:plan_terms_id/complete
            def complete(plan_id:, plan_terms_id:)
              client.get("front/plans/#{plan_id}/plan_terms/#{plan_terms_id}/complete")
            end
          end
        end
      end
    end
  end
end
