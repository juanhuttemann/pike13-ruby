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
            stub_pike13_request(:get, "https://test.pike13.com/api/v2/desk/pack_products", response_body: {
                                  "pack_products" => [{ "id" => 1 }]
                                })

            pack_products = Pike13::API::V2::Desk::PackProduct.all.to_a

            assert_instance_of Array, pack_products
            assert_equal 1, pack_products.size
            assert_instance_of Pike13::API::V2::Desk::PackProduct, pack_products.first
          end

          def test_find_pack_product
            stub_pike13_request(:get, "https://test.pike13.com/api/v2/desk/pack_products/123", response_body: {
                                  "pack_products" => [{ "id" => 123 }]
                                })

            pack_product = Pike13::API::V2::Desk::PackProduct.find(123)

            assert_instance_of Pike13::API::V2::Desk::PackProduct, pack_product
            assert_equal 123, pack_product.id
          end
        end
      end
    end
  end
end
