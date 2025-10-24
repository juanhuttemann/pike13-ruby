# frozen_string_literal: true

require "test_helper"

module Pike13
  module API
    module V2
      module Desk
        class ServiceTest < Minitest::Test
          def setup
            @client = default_client
          end

          def test_all_services
            stub_pike13_request(:get, "/desk/services", response_body: {
                                  "services" => [{ "id" => 1 }]
                                })

            items = @client.desk.services.all

            assert_equal 1, items.size
          end

          def test_find_service
            stub_pike13_request(:get, "/desk/services/123", response_body: {
                                  "services" => [{ "id" => 123 }]
                                })

            item = @client.desk.services.find(123)

            assert_equal 123, item.id
          end

          def test_enrollment_eligibilities
            stub_pike13_request(:get, "/desk/services/123/enrollment_eligibilities", response_body: {
                                  "enrollment_eligibilities" => [
                                    { "person_id" => 1, "eligible" => true, "reasons" => [] },
                                    { "person_id" => 2, "eligible" => false, "reasons" => ["Max enrollments reached"] }
                                  ]
                                })

            eligibilities = @client.desk.services.enrollment_eligibilities(service_id: 123)

            assert_equal 2, eligibilities.size
            assert eligibilities.first["eligible"]
            refute eligibilities.last["eligible"]
          end
        end
      end
    end
  end
end
