# frozen_string_literal: true

module Pike13
  module API
    module V2
      module Front
        class Event < Base
          class << self
            # GET /front/events
            def all
              client.get("front/events")
            end

            # GET /front/events/:id
            def find(id)
              client.get("front/events/#{id}")
            end
          end
        end
      end
    end
  end
end
