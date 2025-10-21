# frozen_string_literal: true

module Pike13
  module API
    module V2
      module Front
        class Service < Pike13::API::V2::Base
          @scope = "front"
          @resource_name = "services"

          # Get enrollment eligibilities for a service
          #
          # @param service_id [Integer] Service ID
          # @param session [Pike13::Client] Client session
          # @param params [Hash] Query parameters (filters, etc.)
          # @return [Array<Hash>] Array of enrollment eligibilities
          #
          # @example
          #   Pike13::API::V2::Front::Service.enrollment_eligibilities(service_id: 123, session: client)
          def self.enrollment_eligibilities(service_id:, session:, **params)
            path = "/#{scope}/#{resource_name}/#{service_id}/enrollment_eligibilities"
            response = session.http_client.get(path, params: params, scoped: scoped?)
            response["enrollment_eligibilities"] || []
          end
        end
      end
    end
  end
end
