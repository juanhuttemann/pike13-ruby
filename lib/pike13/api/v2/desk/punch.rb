# frozen_string_literal: true

module Pike13
  module API
    module V2
      module Desk
        class Punch < Spyke::Base
          uri "desk/punches(/:id)"
          include_root_in_json :punch
        end
      end
    end
  end
end
