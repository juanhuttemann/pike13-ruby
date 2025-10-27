# frozen_string_literal: true

module Pike13
  module API
    module V2
      module Front
        class PersonWaitlistEntry < Base
          class << self
            # GET /front/people/:person_id/waitlist_entries
            def all(person_id:, **params)
              client.get("front/people/#{person_id}/waitlist_entries", params)
            end
          end
        end
      end
    end
  end
end
