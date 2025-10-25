# frozen_string_literal: true

module Pike13
  module API
    module V2
      module Front
        class Location < Base
          uri "front/locations(/:id)"
          include_root_in_json :location
        end
      end
    end
  end
end
