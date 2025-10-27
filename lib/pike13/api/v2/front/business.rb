# frozen_string_literal: true

module Pike13
  module API
    module V2
      module Front
        class Business < Base
          class << self
            # GET /front/business
            def get
              client.get("front/business")
            end
          end
        end
      end
    end
  end
end
