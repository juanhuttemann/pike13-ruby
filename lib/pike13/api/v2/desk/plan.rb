# frozen_string_literal: true

module Pike13
  module API
    module V2
      module Desk
        class Plan < Base
          class << self
            # GET /desk/plans
            def all(**params)
              client.get("desk/plans", params)
            end

            # GET /desk/plans/:id
            def find(id)
              client.get("desk/plans/#{id}")
            end

            # POST /desk/plans/:plan_id/end_date_updates
            def create_end_date_update(plan_id, attributes)
              client.post("desk/plans/#{plan_id}/end_date_updates", attributes)
            end
          end
        end
      end
    end
  end
end
