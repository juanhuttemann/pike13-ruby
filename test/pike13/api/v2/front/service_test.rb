# frozen_string_literal: true

require "test_helper"

module Pike13
  module API
    module V2
      module Front
        class ServiceTest < Minitest::Test
          def setup
            setup_pike13
          end

          def test_all_services
            stub_pike13_request(:get, "https://test.pike13.com/api/v2/front/services", response_body: {
                                  "services" => [{ "id" => 1 }]
                                })

            services = Pike13::API::V2::Front::Service.all

            assert_instance_of Hash, services
            assert_equal 1, services["services"].size
            assert_instance_of Hash, services["services"].first
          end

          def test_find_service
            stub_pike13_request(:get, "https://test.pike13.com/api/v2/front/services/123", response_body: {
                                  "services" => [{ "id" => 123 }]
                                })

            service = Pike13::API::V2::Front::Service.find(123)

            assert_instance_of Hash, service
            assert_equal 123, service["services"].first["id"]
          end

          def test_enrollment_eligibilities
            stub_pike13_request(:get, "https://test.pike13.com/api/v2/front/services/123/enrollment_eligibilities",
                                response_body: {
                                  "enrollment_eligibilities" => [
                                    { "person_id" => 1, "eligible" => true, "reasons" => [] },
                                    { "person_id" => 2, "eligible" => false, "reasons" => ["Max enrollments reached"] }
                                  ]
                                })

            result = Pike13::API::V2::Front::Service.enrollment_eligibilities(service_id: 123)

            eligibilities = result["enrollment_eligibilities"]

            assert_equal 2, eligibilities.size
            assert eligibilities.first["eligible"]
            refute eligibilities.last["eligible"]
          end
        end
      end
    end
  end
end
