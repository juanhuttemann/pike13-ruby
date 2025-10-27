# frozen_string_literal: true

module Pike13
  module API
    module V2
      module Desk
        class Business < Base
          class << self
            # GET /desk/business
            def get
              client.get("desk/business")
            end
          end
        end
      end
    end
  end
end
