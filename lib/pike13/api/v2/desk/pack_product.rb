# frozen_string_literal: true

module Pike13
  module API
    module V2
      module Desk
        class PackProduct < Base
          class << self
            # GET /desk/pack_products
            def all
              client.get("desk/pack_products")
            end

            # GET /desk/pack_products/:id
            def find(id)
              client.get("desk/pack_products/#{id}")
            end
          end
        end
      end
    end
  end
end
