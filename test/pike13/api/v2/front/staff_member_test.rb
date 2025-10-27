# frozen_string_literal: true

require "test_helper"

module Pike13
  module API
    module V2
      module Front
        class StaffMemberTest < Minitest::Test
          def setup
            setup_pike13
          end

          def test_all_staff_members
            stub_pike13_request(:get, "https://test.pike13.com/api/v2/front/staff_members", response_body: {
                                  "staff_members" => [{ "id" => 1 }]
                                })

            staff_members = Pike13::API::V2::Front::StaffMember.all

            assert_instance_of Hash, staff_members
            assert_equal 1, staff_members["staff_members"].size
            assert_instance_of Hash, staff_members["staff_members"].first
          end

          def test_find_staff_member
            stub_pike13_request(:get, "https://test.pike13.com/api/v2/front/staff_members/123", response_body: {
                                  "staff_members" => [{ "id" => 123 }]
                                })

            staff_member = Pike13::API::V2::Front::StaffMember.find(123)

            assert_instance_of Hash, staff_member
            assert_equal 123, staff_member["staff_members"].first["id"]
          end
        end
      end
    end
  end
end
