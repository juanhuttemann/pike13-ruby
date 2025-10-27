# frozen_string_literal: true

module Pike13
  module API
    module V2
      module Front
        class Service < Base
          class << self
            # GET /front/services
            def all
              client.get("front/services")
            end

            # GET /front/services/:id
            def find(id)
              client.get("front/services/#{id}")
            end

            # GET /front/services/:service_id/enrollment_eligibilities
            def enrollment_eligibilities(service_id:, **params)
              client.get("front/services/#{service_id}/enrollment_eligibilities", params)
            end
          end
        end
      end
    end
  end
end
