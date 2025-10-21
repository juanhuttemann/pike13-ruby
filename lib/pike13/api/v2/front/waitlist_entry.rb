# frozen_string_literal: true

module Pike13
  module API
    module V2
      module Front
        class WaitlistEntry < Pike13::API::V2::FindOnlyResource
          @scope = "front"
          @resource_name = "waitlist_entries"
        end
      end
    end
  end
end
