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

            # POST /desk/pack_products
            def create(attributes)
              client.post("desk/pack_products", { pack_product: attributes })
            end

            # PUT /desk/pack_products/:id
            def update(id, attributes)
              client.put("desk/pack_products/#{id}", { pack_product: attributes })
            end

            # DELETE /desk/pack_products/:id
            def destroy(id)
              client.delete("desk/pack_products/#{id}")
            end

            # POST /desk/pack_products/:pack_product_id/packs
            def create_pack(pack_product_id, attributes)
              client.post("desk/pack_products/#{pack_product_id}/packs", { pack: attributes })
            end
          end
        end
      end
    end
  end
end
