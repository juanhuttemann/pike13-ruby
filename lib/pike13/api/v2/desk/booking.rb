# frozen_string_literal: true

module Pike13
  module API
    module V2
      module Desk
        class Booking < Base
          class << self
            # GET /desk/bookings/:id
            def find(id)
              client.get("desk/bookings/#{id}")
            end

            # POST /desk/bookings
            def create(attributes)
              client.post("desk/bookings", { booking: attributes })
            end

            # PUT /desk/bookings/:id
            def update(id, attributes)
              client.put("desk/bookings/#{id}", { booking: attributes })
            end

            # DELETE /desk/bookings/:id
            def destroy(id)
              client.delete("desk/bookings/#{id}")
            end

            # GET /desk/bookings/:booking_id/leases/:id
            def find_lease(booking_id:, id:, **params)
              client.get("desk/bookings/#{booking_id}/leases/#{id}", params)
            end

            # POST /desk/bookings/:booking_id/leases
            def create_lease(booking_id, attributes)
              client.post("desk/bookings/#{booking_id}/leases", { lease: attributes })
            end

            # PUT /desk/bookings/:booking_id/leases/:id
            def update_lease(booking_id, id, attributes)
              client.put("desk/bookings/#{booking_id}/leases/#{id}", { lease: attributes })
            end

            # DELETE /desk/bookings/:booking_id/leases/:lease_id
            def destroy_lease(booking_id, lease_id)
              client.delete("desk/bookings/#{booking_id}/leases/#{lease_id}")
            end
          end
        end
      end
    end
  end
end
