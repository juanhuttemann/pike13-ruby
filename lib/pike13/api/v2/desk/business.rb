# frozen_string_literal: true

module Pike13
  module API
    module V2
      module Desk
        class Business < Pike13::API::V2::SingularResource
          @scope = "desk"
          @resource_name = "business"

          # Get franchisees
          def self.franchisees(session:)
            path = "/#{scope}/#{resource_name}/franchisees"
            response = session.http_client.get(path, scoped: true)
            response["franchisees"] || []
          end
        end
      end
    end
  end
end
