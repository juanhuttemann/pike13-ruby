# frozen_string_literal: true

module Pike13
  module API
    module V2
      module Desk
        class Booking < Spyke::Base
          uri "desk/bookings(/:id)"
          include_root_in_json :booking
        end
      end
    end
  end
end
