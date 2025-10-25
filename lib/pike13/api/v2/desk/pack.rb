# frozen_string_literal: true

module Pike13
  module API
    module V2
      module Desk
        class Pack < Spyke::Base
          uri "desk/packs(/:id)"
          include_root_in_json :pack
        end
      end
    end
  end
end
