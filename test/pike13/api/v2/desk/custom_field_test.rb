# frozen_string_literal: true

require "test_helper"

module Pike13
  module API
    module V2
      module Desk
        class CustomFieldTest < Minitest::Test
          def setup
            setup_pike13
          end

          def test_all_custom_fields
            stub_pike13_request(:get, "https://test.pike13.com/api/v2/desk/custom_fields", response_body: {
                                  "custom_fields" => [{ "id" => 1 }]
                                })

            custom_fields = Pike13::API::V2::Desk::CustomField.all.to_a

            assert_instance_of Array, custom_fields
            assert_equal 1, custom_fields.size
            assert_instance_of Pike13::API::V2::Desk::CustomField, custom_fields.first
          end

          def test_find_custom_field
            stub_pike13_request(:get, "https://test.pike13.com/api/v2/desk/custom_fields/123", response_body: {
                                  "custom_fields" => [{ "id" => 123 }]
                                })

            custom_field = Pike13::API::V2::Desk::CustomField.find(123)

            assert_instance_of Pike13::API::V2::Desk::CustomField, custom_field
            assert_equal 123, custom_field.id
          end
        end
      end
    end
  end
end
