# frozen_string_literal: true

module Pike13
  module API
    module V2
      module Desk
        class Plan < Base
          uri "desk/plans(/:id)"
          include_root_in_json :plan
        end
      end
    end
  end
end
