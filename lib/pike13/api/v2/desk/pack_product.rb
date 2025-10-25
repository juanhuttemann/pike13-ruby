# frozen_string_literal: true

module Pike13
  module API
    module V2
      module Desk
        class PackProduct < Base
          uri "desk/pack_products(/:id)"
          include_root_in_json :pack_product
        end
      end
    end
  end
end
