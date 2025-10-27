# frozen_string_literal: true

module Pike13
  module API
    module V2
      module Front
        class WaitlistEntry < Base
          class << self
            # GET /front/waitlist_entries
            def all
              client.get("front/waitlist_entries")
            end

            # GET /front/waitlist_entries/:id
            def find(id)
              client.get("front/waitlist_entries/#{id}")
            end
          end
        end
      end
    end
  end
end
