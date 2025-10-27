# frozen_string_literal: true

module Pike13
  module API
    module V2
      module Front
        class Booking < Base
          class << self
            # GET /front/bookings/:id
            def find(id)
              client.get("front/bookings/#{id}")
            end

            # GET /front/bookings/:booking_id/leases/:id
            def find_lease(booking_id:, id:, **params)
              client.get("front/bookings/#{booking_id}/leases/#{id}", params)
            end

            # POST /front/bookings
            def create(attributes)
              client.post("front/bookings", { booking: attributes })
            end

            # PUT /front/bookings/:id
            def update(id, attributes)
              client.put("front/bookings/#{id}", { booking: attributes })
            end

            # DELETE /front/bookings/:id
            def destroy(id)
              client.delete("front/bookings/#{id}")
            end
          end
        end
      end
    end
  end
end
