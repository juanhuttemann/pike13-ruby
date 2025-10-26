# frozen_string_literal: true

module Pike13
  module API
    module V2
      module Desk
        class Service < Base
          uri "desk/services(/:id)"
          include_root_in_json :service

          def self.enrollment_eligibilities(service_id:, **params)
            with("desk/services/#{service_id}/enrollment_eligibilities").where(params).to_a
          end
        end
      end
    end
  end
end
