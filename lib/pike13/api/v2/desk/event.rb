# frozen_string_literal: true

module Pike13
  module API
    module V2
      module Desk
        class Event < Pike13::API::V2::Base
          @scope = "desk"
          @resource_name = "events"
        end
      end
    end
  end
end
