# frozen_string_literal: true

module Pike13
  module API
    module V2
      module Desk
        class Business < Base
          class << self
            # GET /desk/business
            def find
              client.get("desk/business")
            end
            alias get find

            # GET /desk/business/franchisees
            def franchisees
              client.get("desk/business/franchisees")
            end
          end
        end
      end
    end
  end
end
