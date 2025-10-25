# frozen_string_literal: true

module Pike13
  module API
    module V2
      module Front
        class EventOccurrence < Spyke::Base
          uri "front/event_occurrences(/:id)"
          include_root_in_json :event_occurrence

          class << self
            def summary(**params)
              result = with("front/event_occurrences/summary").where(params).get
              result.data["event_occurrence_summaries"] || []
            end

            def enrollment_eligibilities(id:, **params)
              result = with("front/event_occurrences/#{id}/enrollment_eligibilities").where(params).get
              result.data["enrollment_eligibilities"] || []
            end
          end
        end
      end
    end
  end
end
