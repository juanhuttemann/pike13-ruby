# frozen_string_literal: true

module Pike13
  module API
    module V2
      module Desk
        class Service < Base
          class << self
            # GET /desk/services
            def all
              client.get("desk/services")
            end

            # GET /desk/services/:id
            def find(id)
              client.get("desk/services/#{id}")
            end

            # GET /desk/services/:service_id/enrollment_eligibilities
            def enrollment_eligibilities(service_id:, **params)
              client.get("desk/services/#{service_id}/enrollment_eligibilities", params)
            end
          end
        end
      end
    end
  end
end
