# frozen_string_literal: true

module Pike13
  module API
    module V2
      module Desk
        class Visit < Spyke::Base
          uri "desk/visits(/:id)"
          include_root_in_json :visit
        end
      end
    end
  end
end
