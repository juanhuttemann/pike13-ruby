# frozen_string_literal: true

module Pike13
  module API
    module V2
      module Desk
        class Event < Base
          class << self
            # GET /desk/events
            def all
              client.get("desk/events")
            end

            # GET /desk/events/:id
            def find(id)
              client.get("desk/events/#{id}")
            end
          end
        end
      end
    end
  end
end
