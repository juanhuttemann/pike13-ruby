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
            stub_pike13_request(:get, "/desk/staff_members", scope: "desk", response_body: {
                                  "staff_members" => [{ "id" => 1, "name" => "Staff" }]
                                })

            staff = @client.desk.staff_members.all

            assert_equal 1, staff.size
          end

          def test_find_staff_member
            stub_pike13_request(:get, "/desk/staff_members/123", scope: "desk", response_body: {
                                  "staff_members" => [{ "id" => 123, "name" => "Staff" }]
                                })

            staff = @client.desk.staff_members.find(123)

            assert_equal 123, staff.id
          end
        end
      end
    end
  end
end
