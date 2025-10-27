# frozen_string_literal: true

module Pike13
  module API
    module V2
      module Desk
        class EventOccurrence < Base
          class << self
            # GET /desk/event_occurrences
            def all
              client.get("desk/event_occurrences")
            end

            # GET /desk/event_occurrences/:id
            def find(id)
              client.get("desk/event_occurrences/#{id}")
            end

            # GET /desk/event_occurrences/summary
            def summary(**params)
              client.get("desk/event_occurrences/summary", params)
            end

            # GET /desk/event_occurrences/:id/enrollment_eligibilities
            def enrollment_eligibilities(id:, **params)
              client.get("desk/event_occurrences/#{id}/enrollment_eligibilities", params)
            end
          end
        end
      end
    end
  end
end
