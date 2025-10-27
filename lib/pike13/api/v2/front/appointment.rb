# frozen_string_literal: true

module Pike13
  module API
    module V2
      module Front
        class Appointment < Base
          class << self
            # GET /front/appointments/:id
            def find(id)
              client.get("front/appointments/#{id}")
            end

            # GET /front/appointments/:service_id/available_slots
            def find_available_slots(service_id:, **params)
              client.get("front/appointments/#{service_id}/available_slots", params)
            end

            # GET /front/appointments/:service_id/available_slots/summary
            def available_slots_summary(service_id:, **params)
              client.get("front/appointments/#{service_id}/available_slots/summary", params)
            end
          end
        end
      end
    end
  end
end
