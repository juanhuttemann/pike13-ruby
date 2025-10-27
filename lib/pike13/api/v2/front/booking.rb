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

            # POST /front/bookings/:booking_id/leases
            def create_lease(booking_id, attributes)
              client.post("front/bookings/#{booking_id}/leases", { lease: attributes })
            end

            # PUT /front/bookings/:booking_id/leases/:id
            def update_lease(booking_id, id, attributes)
              client.put("front/bookings/#{booking_id}/leases/#{id}", { lease: attributes })
            end

            # DELETE /front/bookings/:booking_id/leases/:lease_id
            def destroy_lease(booking_id, lease_id)
              client.delete("front/bookings/#{booking_id}/leases/#{lease_id}")
            end
          end
        end
      end
    end
  end
end
