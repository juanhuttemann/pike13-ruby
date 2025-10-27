# frozen_string_literal: true

module Pike13
  module API
    module V2
      module Front
        class StaffMember < Base
          class << self
            # GET /front/staff_members
            def all
              client.get("front/staff_members")
            end

            # GET /front/staff_members/:id
            def find(id)
              client.get("front/staff_members/#{id}")
            end
          end
        end
      end
    end
  end
end
