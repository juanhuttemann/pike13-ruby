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

            custom_fields = Pike13::API::V2::Desk::CustomField.all

            assert_instance_of Hash, custom_fields
            assert_equal 1, custom_fields["custom_fields"].size
            assert_instance_of Hash, custom_fields["custom_fields"].first
          end
        end
      end
    end
  end
end
