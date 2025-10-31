# frozen_string_literal: true

module Pike13
  module API
    module V3
      module Desk
        # Enrollments resource
        # Data about visit and waitlist history, behavior, and trends
        #
        # @example Basic query
        #   Pike13::Reporting::Enrollments.query(
        #     fields: ['visit_id', 'full_name', 'service_name', 'state', 'service_date']
        #   )
        #
        # @example Query completed visits
        #   Pike13::Reporting::Enrollments.query(
        #     fields: ['full_name', 'service_name', 'service_date', 'estimated_amount'],
        #     filter: ['eq', 'state', 'completed']
        #   )
        #
        # @example Group by service
        #   Pike13::Reporting::Enrollments.query(
        #     fields: ['completed_enrollment_count', 'total_visits_amount'],
        #     group: 'service_name'
        #   )
        class Enrollments < Base
          class << self
            # Execute an enrollments query
            #
            # @param fields [Array<String>] Fields to return (detail or summary fields)
            # @param filter [Array, nil] Filter criteria (optional)
            # @param group [String, nil] Grouping field (optional)
            # @param sort [Array<String>, nil] Sort order (optional)
            # @param page [Hash, nil] Pagination options (optional)
            # @param total_count [Boolean] Whether to return total count (optional)
            # @return [Hash] Query result with rows, fields, and metadata
            #
            # @see https://developer.pike13.com/docs/api/v3/reports/enrollments
            def query(fields:, filter: nil, group: nil, sort: nil, page: nil, total_count: nil)
              query_params = { fields: fields }
              query_params[:filter] = filter if filter
              query_params[:group] = group if group
              query_params[:sort] = sort if sort
              query_params[:page] = page if page
              query_params[:total_count] = total_count if total_count

              super("enrollments", query_params)
            end

            # Available detail fields (when not grouping)
            DETAIL_FIELDS = %w[
              account_manager_emails
              account_manager_names
              account_manager_phones
              address
              available_plans
              birthdate
              bulk_enrolled
              business_id
              business_name
              business_subdomain
              cancelled_at
              cancelled_to_start
              client_booked
              completed_at
              consider_member
              currency_code
              duration_in_hours
              duration_in_minutes
              email
              end_at
              estimated_amount
              event_id
              event_name
              event_occurrence_id
              first_visit
              franchise_id
              full_name
              home_location_name
              instructor_names
              is_paid
              is_rollover
              is_waitlist
              key
              make_up_issued
              noshow_at
              paid_with
              paid_with_complimentary_pass
              paid_with_type
              person_id
              phone
              plan_id
              plan_product_id
              primary_staff_name
              punch_id
              punchcard_id
              registered_at
              service_category
              service_date
              service_day
              service_id
              service_location_id
              service_location_name
              service_name
              service_state
              service_time
              service_type
              start_at
              state
              visit_id
              waitlist_id
              waitlisted_at
            ].freeze

            # Available summary fields (when grouping)
            SUMMARY_FIELDS = %w[
              avg_per_visit_amount
              business_id_summary
              business_subdomain_summary
              client_booked_count
              completed_enrollment_count
              consider_member_count
              enrollment_count
              event_count
              event_occurrence_count
              expired_enrollment_count
              first_visit_count
              is_paid_count
              is_rollover_count
              is_waitlist_count
              late_canceled_enrollment_count
              noshowed_enrollment_count
              person_count
              registered_enrollment_count
              removed_enrollment_count
              reserved_enrollment_count
              service_count
              total_count
              total_duration_in_hours
              total_duration_in_minutes
              total_visits_amount
              unpaid_visit_count
              unpaid_visit_percent
              visit_count
              waiting_enrollment_count
              weekday_0_enrollment_count
              weekday_1_enrollment_count
              weekday_2_enrollment_count
              weekday_3_enrollment_count
              weekday_4_enrollment_count
              weekday_5_enrollment_count
              weekday_6_enrollment_count
            ].freeze

            # Available grouping fields
            GROUPINGS = %w[
              business_id
              business_name
              business_subdomain
              client_booked
              consider_member
              event_id
              event_name
              event_occurrence_id
              first_visit
              full_name
              home_location_name
              instructor_names
              is_paid
              is_rollover
              is_waitlist
              paid_with
              paid_with_complimentary_pass
              paid_with_type
              person_id
              plan_id
              plan_product_id
              primary_staff_name
              punch_id
              punchcard_id
              service_category
              service_date
              service_day
              service_id
              service_location_id
              service_location_name
              service_month_start_date
              service_name
              service_quarter_start_date
              service_state
              service_time
              service_type
              service_week_mon_start_date
              service_week_sun_start_date
              service_year_start_date
              state
            ].freeze
          end
        end
      end
    end
  end
end
