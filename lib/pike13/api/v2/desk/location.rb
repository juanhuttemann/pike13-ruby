# frozen_string_literal: true

module Pike13
  module API
    module V2
      module Desk
        class Location < Base
          class << self
            # GET /desk/locations
            def all
              client.get("desk/locations")
            end

            # GET /desk/locations/:id
            def find(id)
              client.get("desk/locations/#{id}")
            end
          end
        end
      end
    end
  end
end
