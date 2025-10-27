# frozen_string_literal: true

module Pike13
  module API
    module V2
      module Front
        class Visit < Base
          class << self
            # GET /front/visits
            def all
              client.get("front/visits")
            end

            # GET /front/visits/:id
            def find(id)
              client.get("front/visits/#{id}")
            end
          end
        end
      end
    end
  end
end
