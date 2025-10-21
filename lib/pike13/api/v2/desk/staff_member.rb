# frozen_string_literal: true

module Pike13
  module API
    module V2
      module Desk
        class StaffMember < Pike13::API::V2::Base
          @scope = "desk"
          @resource_name = "staff_members"

          # Get current authenticated staff member
          #
          # @param session [Pike13::Client] Client session
          # @return [Pike13::API::V2::Desk::StaffMember]
          def self.me(session:)
            path = "/#{scope}/#{resource_name}/me"
            response = session.http_client.get(path, scoped: true)

            data = response[resource_name]&.first || {}
            new(session: session, **data.transform_keys(&:to_sym))
          end
        end
      end
    end
  end
end
