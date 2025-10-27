# frozen_string_literal: true

module Pike13
  module API
    module V2
      module Front
        class Business < Base
          class << self
            # GET /front/business
            def find
              client.get("front/business")
            end
            alias get find

            # GET /front/business/franchisees
            def franchisees
              client.get("front/business/franchisees")
            end
          end
        end
      end
    end
  end
end
