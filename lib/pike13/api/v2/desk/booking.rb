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
          end
        end
      end
    end
  end
end
