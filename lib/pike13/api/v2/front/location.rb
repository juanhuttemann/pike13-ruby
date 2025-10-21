# frozen_string_literal: true

module Pike13
  module API
    module V2
      module Front
        class Location < Pike13::API::V2::Base
          @scope = "front"
          @resource_name = "locations"
        end
      end
    end
  end
end
