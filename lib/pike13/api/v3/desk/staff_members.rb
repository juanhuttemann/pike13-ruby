# frozen_string_literal: true

module Pike13
  module API
    module V3
      module Desk
        # Staff Members resource
        # All staff member data — from tenure and events to birthdays and custom fields
        #
        # @example Basic query
        #   Pike13::Reporting::StaffMembers.query(
        #     fields: ['person_id', 'full_name', 'email', 'role', 'person_state']
        #   )
        #
        # @example Query active staff members
        #   Pike13::Reporting::StaffMembers.query(
        #     fields: ['full_name', 'email', 'role', 'tenure', 'future_events'],
        #     filter: ['eq', 'person_state', 'active']
        #   )
        #
        # @example Group by role
        #   Pike13::Reporting::StaffMembers.query(
        #     fields: ['person_count', 'total_future_events', 'total_past_events'],
        #     group: 'role'
        #   )
        class StaffMembers < Base
          class << self
            # Execute a staff members query
            #
            # @param fields [Array<String>] Fields to return (detail or summary fields)
            # @param filter [Array, nil] Filter criteria (optional)
            # @param group [String, nil] Grouping field (optional)
            # @param sort [Array<String>, nil] Sort order (optional)
            # @param page [Hash, nil] Pagination options (optional)
            # @param total_count [Boolean] Whether to return total count (optional)
            # @return [Hash] Query result with rows, fields, and metadata
            #
            # @see https://developer.pike13.com/docs/api/v3/reports/staff_members
            def query(fields:, filter: nil, group: nil, sort: nil, page: nil, total_count: nil)
              query_params = { fields: fields }
              query_params[:filter] = filter if filter
              query_params[:group] = group if group
              query_params[:sort] = sort if sort
              query_params[:page] = page if page
              query_params[:total_count] = total_count if total_count

              super("staff_members", query_params)
            end

            # Available detail fields (when not grouping)
            DETAIL_FIELDS = %w[
              address
              age
              also_client
              attendance_not_completed_events
              birthdate
              business_id
              business_name
              business_subdomain
              city
              country_code
              currency_code
              custom_fields
              days_until_birthday
              email
              first_name
              franchise_id
              full_name
              future_events
              home_location_id
              home_location_name
              key
              last_name
              middle_name
              past_events
              person_id
              person_state
              phone
              postal_code
              role
              show_to_clients
              staff_since_date
              state_code
              street_address
              street_address2
              tenure
              tenure_group
            ].freeze

            # Available summary fields (when grouping)
            SUMMARY_FIELDS = %w[
              also_client_count
              business_id_summary
              business_subdomain_summary
              demoted_staff_count
              person_count
              total_attendance_not_completed_events
              total_count
              total_future_events
              total_past_events
            ].freeze

            # Available grouping fields
            GROUPINGS = %w[
              age
              also_client
              business_id
              business_name
              business_subdomain
              home_location_name
              person_state
              role
              show_to_clients
              staff_since_date
              staff_since_month_start_date
              staff_since_quarter_start_date
              staff_since_week_mon_start_date
              staff_since_week_sun_start_date
              staff_since_year_start_date
              tenure_group
            ].freeze
          end
        end
      end
    end
  end
end
