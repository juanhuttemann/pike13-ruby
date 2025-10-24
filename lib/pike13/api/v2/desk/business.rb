# frozen_string_literal: true

module Pike13
  module API
    module V2
      module Desk
        class Business < Pike13::API::V2::SingletonResource
          @resource_name = "business"

          # Get franchisees
          def self.franchisees(client:)
            path = "/#{scope}/#{resource_name}/franchisees"
            response = client.get(path)
            response["franchisees"] || []
          end
        end
      end
    end
  end
end
