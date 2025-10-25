# frozen_string_literal: true

module Pike13
  module API
    module V2
      module Front
        class Visit < Base
          uri "front/visits(/:id)"
          include_root_in_json :visit
        end
      end
    end
  end
end
