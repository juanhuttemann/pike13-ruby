# frozen_string_literal: true

module Pike13
  module API
    module V2
      module Desk
        class Plan < Base
          class << self
            # GET /desk/plans
            def all
              client.get("desk/plans")
            end

            # GET /desk/plans/:id
            def find(id)
              client.get("desk/plans/#{id}")
            end
          end
        end
      end
    end
  end
end
