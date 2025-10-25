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

            staff_members = @client.desk.staff_members.all.to_a

            assert_instance_of Array, staff_members
            assert_equal 1, staff_members.size
            assert_instance_of Pike13::API::V2::Desk::StaffMember, staff_members.first
          end

          def test_find_staff_member
            stub_pike13_request(:get, "/desk/staff_members/123", response_body: {
                                  "staff_members" => [{ "id" => 123, "name" => "Staff" }]
                                })

            staff_member = @client.desk.staff_members.find(123)

            assert_instance_of Pike13::API::V2::Desk::StaffMember, staff_member
            assert_equal 123, staff_member.id
          end

          def test_me
            stub_pike13_request(:get, "/desk/staff_members/me", response_body: {
                                  "staff_members" => [{ "id" => 999, "name" => "Current Staff" }]
                                })

            staff_member = @client.desk.staff_members.me

            assert_instance_of Pike13::API::V2::Desk::StaffMember, staff_member
            assert_equal 999, staff_member.id
          end
        end
      end
    end
  end
end
