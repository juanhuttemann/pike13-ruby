# frozen_string_literal: true

require "test_helper"

module Pike13
  module API
    module V2
      module Desk
        class PackProductTest < Minitest::Test
          def setup
            setup_pike13
          end

          def test_all_pack_products
            stub_pike13_request(:get, "https://test.pike13.com/api/v2/desk/pack_products", response_body: {
                                  "pack_products" => [{ "id" => 1 }]
                                })

            pack_products = Pike13::API::V2::Desk::PackProduct.all

            assert_instance_of Hash, pack_products
            assert_equal 1, pack_products["pack_products"].size
            assert_instance_of Hash, pack_products["pack_products"].first
          end

          def test_find_pack_product
            stub_pike13_request(:get, "https://test.pike13.com/api/v2/desk/pack_products/123", response_body: {
                                  "pack_products" => [{ "id" => 123 }]
                                })

            pack_product = Pike13::API::V2::Desk::PackProduct.find(123)

            assert_instance_of Hash, pack_product
            assert_equal 123, pack_product["pack_products"].first["id"]
          end

          def test_create_pack_product
            stub_pike13_request(:post, "https://test.pike13.com/api/v2/desk/pack_products",
                                response_body: {
                                  "pack_products" => [{ "id" => 456, "name" => "10 Pack", "count" => 10 }]
                                })

            result = Pike13::API::V2::Desk::PackProduct.create(
              name: "10 Pack",
              count: 10,
              price_cents: 10_000
            )

            assert_instance_of Hash, result
            assert_equal 456, result["pack_products"].first["id"]
            assert_equal "10 Pack", result["pack_products"].first["name"]
          end

          def test_update_pack_product
            stub_pike13_request(:put, "https://test.pike13.com/api/v2/desk/pack_products/456",
                                response_body: {
                                  "pack_products" => [{ "id" => 456, "name" => "Updated Pack" }]
                                })

            result = Pike13::API::V2::Desk::PackProduct.update(456, name: "Updated Pack")

            assert_instance_of Hash, result
            assert_equal 456, result["pack_products"].first["id"]
            assert_equal "Updated Pack", result["pack_products"].first["name"]
          end

          def test_destroy_pack_product
            stub_pike13_request(:delete, "https://test.pike13.com/api/v2/desk/pack_products/456",
                                response_body: {})

            result = Pike13::API::V2::Desk::PackProduct.destroy(456)

            assert_instance_of Hash, result
          end

          def test_create_pack
            stub_pike13_request(:post, "https://test.pike13.com/api/v2/desk/pack_products/123/packs",
                                response_body: {
                                  "packs" => [{ "id" => 789, "pack_product_id" => 123, "person_id" => 456 }]
                                })

            result = Pike13::API::V2::Desk::PackProduct.create_pack(123, person_id: 456)

            assert_instance_of Hash, result
            assert_equal 789, result["packs"].first["id"]
            assert_equal 123, result["packs"].first["pack_product_id"]
          end
        end
      end
    end
  end
end
