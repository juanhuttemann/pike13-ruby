# frozen_string_literal: true

module Pike13
  module API
    module V2
      module Front
        class WaitlistEntry < Base
          uri "front/waitlist_entries(/:id)"
          include_root_in_json :waitlist_entry
        end
      end
    end
  end
end
