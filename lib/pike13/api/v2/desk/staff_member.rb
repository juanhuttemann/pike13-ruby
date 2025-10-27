# frozen_string_literal: true

module Pike13
  module API
    module V2
      module Desk
        class StaffMember < Base
          class << self
            # GET /desk/staff_members
            def all
              client.get("desk/staff_members")
            end

            # GET /desk/staff_members/:id
            def find(id)
              client.get("desk/staff_members/#{id}")
            end

            # GET /desk/staff_members/me
            def me
              find(:me)
            end
          end
        end
      end
    end
  end
end
