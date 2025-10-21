# frozen_string_literal: true

module Pike13
  module API
    module V2
      module Front
        class Business < Pike13::API::V2::SingularResource
          @scope = "front"
          @resource_name = "business"
        end
      end
    end
  end
end
