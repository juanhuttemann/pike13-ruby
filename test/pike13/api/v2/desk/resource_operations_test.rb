# frozen_string_literal: true

require "test_helper"

module Pike13
  module API
    module V2
      module Desk
        class ResourceOperationsTest < Minitest::Test
          def setup
            setup_pike13
          end

          def test_plan_end_date_update
            stub_pike13_request(:post, "https://test.pike13.com/api/v2/desk/plans/123/end_date_updates",
                                response_body: {
                                  "end_date" => "2025-12-31"
                                })

            result = Pike13::API::V2::Desk::Plan.create_end_date_update(123, { end_date: "2025-12-31" })

            assert_instance_of Hash, result
            assert_equal "2025-12-31", result["end_date"]
          end

          def test_create_punch
            stub_pike13_request(:post, "https://test.pike13.com/api/v2/desk/punches",
                                response_body: {
                                  "punches" => [{ "id" => 123 }]
                                })

            result = Pike13::API::V2::Desk::Punch.create({ visit_id: 456, plan_id: 789 })

            assert_instance_of Hash, result
            assert_equal 123, result["punches"].first["id"]
          end

          def test_destroy_punch
            stub_pike13_request(:delete, "https://test.pike13.com/api/v2/desk/punches/123", response_body: {})

            result = Pike13::API::V2::Desk::Punch.destroy(123)

            assert_instance_of Hash, result
          end

          def test_create_pack_product
            stub_pike13_request(:post, "https://test.pike13.com/api/v2/desk/pack_products", response_body: {
                                  "pack_products" => [{ "id" => 123, "name" => "10 Pack" }]
                                })

            result = Pike13::API::V2::Desk::PackProduct.create({ name: "10 Pack", price_cents: 10_000 })

            assert_instance_of Hash, result
            assert_equal 123, result["pack_products"].first["id"]
          end

          def test_update_pack_product
            stub_pike13_request(:put, "https://test.pike13.com/api/v2/desk/pack_products/123", response_body: {
                                  "pack_products" => [{ "id" => 123, "name" => "Updated Pack" }]
                                })

            result = Pike13::API::V2::Desk::PackProduct.update(123, { name: "Updated Pack" })

            assert_instance_of Hash, result
            assert_equal "Updated Pack", result["pack_products"].first["name"]
          end

          def test_destroy_pack_product
            stub_pike13_request(:delete, "https://test.pike13.com/api/v2/desk/pack_products/123", response_body: {})

            result = Pike13::API::V2::Desk::PackProduct.destroy(123)

            assert_instance_of Hash, result
          end

          def test_create_pack
            stub_pike13_request(:post, "https://test.pike13.com/api/v2/desk/pack_products/123/packs", response_body: {
                                  "packs" => [{ "id" => 456 }]
                                })

            result = Pike13::API::V2::Desk::PackProduct.create_pack(123, { person_id: 1 })

            assert_instance_of Hash, result
            assert_equal 456, result["packs"].first["id"]
          end

          def test_destroy_pack
            stub_pike13_request(:delete, "https://test.pike13.com/api/v2/desk/packs/123", response_body: {})

            result = Pike13::API::V2::Desk::Pack.destroy(123)

            assert_instance_of Hash, result
          end
        end
      end
    end
  end
end
