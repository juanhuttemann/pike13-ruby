# frozen_string_literal: true

module Pike13
  module API
    module V2
      module Front
        class StaffMember < Spyke::Base
          uri "front/staff_members(/:id)"
          include_root_in_json :staff_member
        end
      end
    end
  end
end
