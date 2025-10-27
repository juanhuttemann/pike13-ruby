# frozen_string_literal: true

module Pike13
  module API
    module V2
      module Front
        class Location < Base
          class << self
            # GET /front/locations
            def all
              client.get("front/locations")
            end

            # GET /front/locations/:id
            def find(id)
              client.get("front/locations/#{id}")
            end
          end
        end
      end
    end
  end
end
