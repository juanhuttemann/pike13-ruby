# frozen_string_literal: true

module Pike13
  module API
    module V2
      module Desk
        class WaitlistEntry < Base
          class << self
            # GET /desk/waitlist_entries
            def all
              client.get("desk/waitlist_entries")
            end

            # GET /desk/waitlist_entries/:id
            def find(id)
              client.get("desk/waitlist_entries/#{id}")
            end
          end
        end
      end
    end
  end
end
