# frozen_string_literal: true

require "test_helper"

module Pike13
  module API
    module V2
      module Desk
        class PackProductTest < Minitest::Test
          def setup
            @client = default_client
          end

          def test_all_pack_products
            stub_pike13_request(:get, "/desk/pack_products", response_body: {
                                  "pack_products" => [{ "id" => 1 }]
                                })

            items = @client.desk.pack_products.all

            assert_equal 1, items.size
          end

          def test_find_pack_product
            stub_pike13_request(:get, "/desk/pack_products/123", response_body: {
                                  "pack_products" => [{ "id" => 123 }]
                                })

            item = @client.desk.pack_products.find(123)

            assert_equal 123, item.id
          end
        end
      end
    end
  end
end
