# frozen_string_literal: true

module Pike13
  module API
    module V2
      module Desk
        class Location < Spyke::Base
          uri "desk/locations(/:id)"
          include_root_in_json :location
        end
      end
    end
  end
end
