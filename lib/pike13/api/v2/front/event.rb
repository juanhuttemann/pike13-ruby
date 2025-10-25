# frozen_string_literal: true

module Pike13
  module API
    module V2
      module Front
        class Event < Base
          uri "front/events(/:id)"
          include_root_in_json :event
        end
      end
    end
  end
end
