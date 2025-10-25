# frozen_string_literal: true

require "test_helper"

module Pike13
  module API
    module V2
      module Desk
        class StaffMemberTest < Minitest::Test
          def setup
            @client = default_client
          end

          def test_all_staff_members
            stub_pike13_request(:get, "/desk/staff_members", response_body: {
                                  "staff_members" => [{ "id" => 1, "name" => "Staff" }]
                                })

            staff = @client.desk.staff_members.all.to_a

            assert_equal 1, staff.size
            assert_instance_of Pike13::API::V2::Desk::StaffMember, staff.first
          end

          def test_find_staff_member
            stub_pike13_request(:get, "/desk/staff_members/123", response_body: {
                                  "staff_members" => [{ "id" => 123, "name" => "Staff" }]
                                })

            staff = @client.desk.staff_members.find(123)

            assert_equal 123, staff.id
            assert_instance_of Pike13::API::V2::Desk::StaffMember, staff
          end

          def test_me
            stub_pike13_request(:get, "/desk/staff_members/me", response_body: {
                                  "staff_members" => [{ "id" => 999, "name" => "Current Staff" }]
                                })

            staff = @client.desk.staff_members.me

            assert_equal 999, staff.id
            assert_instance_of Pike13::API::V2::Desk::StaffMember, staff
          end
        end
      end
    end
  end
end
