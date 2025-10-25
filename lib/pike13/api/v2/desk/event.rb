# frozen_string_literal: true

module Pike13
  module API
    module V2
      module Desk
        class Event < Base
          uri "desk/events(/:id)"
          include_root_in_json :event
        end
      end
    end
  end
end
