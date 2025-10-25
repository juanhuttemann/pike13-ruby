# frozen_string_literal: true

module Pike13
  module API
    module V2
      module Desk
        class StaffMember < Base
          uri "desk/staff_members(/:id)"
          include_root_in_json :staff_member

          class << self
            def me
              find(:me)
            end
          end
        end
      end
    end
  end
end
