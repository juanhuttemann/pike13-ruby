# frozen_string_literal: true

module Pike13
  module API
    module V2
      module Front
        class Event < Pike13::API::V2::Base
          @scope = "front"
          @resource_name = "events"
        end
      end
    end
  end
end
