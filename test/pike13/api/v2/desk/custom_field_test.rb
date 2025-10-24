# frozen_string_literal: true

require "test_helper"

module Pike13
  module API
    module V2
      module Desk
        class CustomFieldTest < Minitest::Test
          def setup
            @client = default_client
          end

          def test_all_custom_fields
            stub_pike13_request(:get, "/desk/custom_fields", response_body: {
                                  "custom_fields" => [{ "id" => 1 }]
                                })

            items = @client.desk.custom_fields.all

            assert_equal 1, items.size
          end

          def test_find_custom_field
            stub_pike13_request(:get, "/desk/custom_fields/123", response_body: {
                                  "custom_fields" => [{ "id" => 123 }]
                                })

            item = @client.desk.custom_fields.find(123)

            assert_equal 123, item.id
          end
        end
      end
    end
  end
end
