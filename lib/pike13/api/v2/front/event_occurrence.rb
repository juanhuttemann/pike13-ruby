# frozen_string_literal: true

module Pike13
  module API
    module V2
      module Front
        class EventOccurrence < Base
          class << self
            # GET /front/event_occurrences
            def all(**params)
              client.get("front/event_occurrences", params)
            end

            # GET /front/event_occurrences/:id
            def find(id)
              client.get("front/event_occurrences/#{id}")
            end

            # GET /front/event_occurrences/summary
            def summary(**params)
              client.get("front/event_occurrences/summary", params)
            end

            # GET /front/event_occurrences/:id/enrollment_eligibilities
            def enrollment_eligibilities(id:, **params)
              client.get("front/event_occurrences/#{id}/enrollment_eligibilities", params)
            end
          end
        end
      end
    end
  end
end
