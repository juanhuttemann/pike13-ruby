# frozen_string_literal: true

module Pike13
  module API
    module V2
      module Desk
        class StaffMember < Pike13::API::V2::Base
          @resource_name = "staff_members"

          # Get current authenticated staff member
          #
          # @param client [Pike13::Client] Client client
          # @return [Pike13::API::V2::Desk::StaffMember]
          def self.me(client:)
            path = "/#{scope}/#{resource_name}/me"
            response = client.get(path)

            data = response[resource_name]&.first || {}
            new(client: client, **data.transform_keys(&:to_sym))
          end
        end
      end
    end
  end
end
