# frozen_string_literal: true

module Pike13
  module API
    module V2
      module Desk
        class Appointment < Base
          class << self
            # GET /desk/appointments/:id
            def find(id)
              client.get("desk/appointments/#{id}")
            end

            # GET /desk/appointments/:service_id/available_slots
            def find_available_slots(service_id:, **params)
              client.get("desk/appointments/#{service_id}/available_slots", params)
            end

            # GET /desk/appointments/:service_id/available_slots/summary
            def available_slots_summary(service_id:, **params)
              client.get("desk/appointments/#{service_id}/available_slots/summary", params)
            end
          end
        end
      end
    end
  end
end
