# frozen_string_literal: true

module Pike13
  module API
    module V2
      module Front
        class Plan < Pike13::API::V2::Base
          @scope = "front"
          @resource_name = "plans"

          # Get plan terms for this plan
          #
          # @return [Array<Hash>] Plan terms data
          def plan_terms
            path = "/front/plans/#{id}/plan_terms"
            response = session.http_client.get(path, scoped: true)
            response["plan_terms"] || []
          end
        end
      end
    end
  end
end
