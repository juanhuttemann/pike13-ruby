# frozen_string_literal: true

module Pike13
  module API
    module V2
      module Desk
        class PersonWaitlistEntry < Base
          class << self
            # GET /desk/people/:person_id/waitlist_entries
            def all(person_id:, **params)
              client.get("desk/people/#{person_id}/waitlist_entries", params)
            end
          end
        end
      end
    end
  end
end
