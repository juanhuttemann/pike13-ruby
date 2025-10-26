# frozen_string_literal: true

module Pike13
  module API
    module V2
      module Front
        class EventOccurrence < Base
          uri "front/event_occurrences(/:id)"
          include_root_in_json :event_occurrence

          def self.summary(**params)
            with("front/event_occurrences/summary").where(params).to_a
          end

          def self.enrollment_eligibilities(id:, **params)
            with("front/event_occurrences/#{id}/enrollment_eligibilities").where(params).to_a
          end
        end
      end
    end
  end
end
