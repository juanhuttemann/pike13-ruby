# frozen_string_literal: true

module Pike13
  module API
    module V2
      module Desk
        class Service < Pike13::API::V2::Base
          @resource_name = "services"

          # Get enrollment eligibilities for a service
          #
          # @param service_id [Integer] Service ID
          # @param client [Pike13::Client] Client client
          # @param params [Hash] Query parameters (filters, etc.)
          # @return [Array<Hash>] Array of enrollment eligibilities
          #
          # @example
          #   Pike13::API::V2::Desk::Service.enrollment_eligibilities(service_id: 123, client: client)
          def self.enrollment_eligibilities(service_id:, client:, **params)
            path = "/#{scope}/#{resource_name}/#{service_id}/enrollment_eligibilities"
            response = client.get(path, params: params)
            response["enrollment_eligibilities"] || []
          end
        end
      end
    end
  end
end
