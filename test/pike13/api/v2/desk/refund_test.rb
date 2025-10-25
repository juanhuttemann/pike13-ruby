# frozen_string_literal: true

require "test_helper"

module Pike13
  module API
    module V2
      module Desk
        class RefundTest < Minitest::Test
          def setup
            @client = default_client
          end

          def test_void_refund
            stub_pike13_request(:post, "https://test.pike13.com/api/v2/desk/refunds/123/voids", response_body: {
                                  "refunds" => [{
                                    "id" => 123,
                                    "amount_cents" => 100,
                                    "amount" => "1.00",
                                    "state" => "completed",
                                    "description" => "Visa 1111, 1/20",
                                    "created_at" => "2025-10-24T00:24:21Z",
                                    "voided_at" => "2025-10-25T00:46:32Z",
                                    "is_voidable" => false
                                  }]
                                })

            refund = Pike13::API::V2::Desk::Refund.void(
              refund_id: 123
            )

            assert_equal 123, refund["id"]
            assert_equal "completed", refund["state"]
            assert_equal "2025-10-25T00:46:32Z", refund["voided_at"]
            refute refund["is_voidable"]
          end

          def test_void_refund_with_amount
            stub_pike13_request(:post, "https://test.pike13.com/api/v2/desk/refunds/456/voids", response_body: {
                                  "refunds" => [{
                                    "id" => 456,
                                    "amount_cents" => 5000,
                                    "amount" => "50.00",
                                    "state" => "completed",
                                    "voided_at" => "2025-10-25T12:00:00Z",
                                    "is_voidable" => false
                                  }]
                                })

            refund = Pike13::API::V2::Desk::Refund.void(
              refund_id: 456
            )

            assert_equal 456, refund["id"]
            assert_equal 5000, refund["amount_cents"]
            assert_equal "50.00", refund["amount"]
            assert_equal "2025-10-25T12:00:00Z", refund["voided_at"]
          end
        end
      end
    end
  end
end
