# frozen_string_literal: true

module Pike13
  module API
    module V3
      module Desk
        # Monthly Business Metrics resource
        # Summary of monthly transaction amounts, members, and enrollments
        #
        # @example Basic query
        #   Pike13::Reporting::MonthlyBusinessMetrics.query(
        #     fields: ['month_start_date', 'net_paid_amount', 'new_client_count']
        #   )
        #
        # @example Query with filters and sorting
        #   Pike13::Reporting::MonthlyBusinessMetrics.query(
        #     fields: ['month_start_date', 'net_paid_amount', 'member_count'],
        #     filter: ['btw', 'month_start_date', '2024-01-01', '2024-12-31'],
        #     sort: ['month_start_date-']
        #   )
        #
        # @example Query with grouping
        #   Pike13::Reporting::MonthlyBusinessMetrics.query(
        #     fields: ['total_net_paid_amount', 'total_new_client_count'],
        #     group: 'year_start_date'
        #   )
        #
        # @example Query with pagination
        #   Pike13::Reporting::MonthlyBusinessMetrics.query(
        #     fields: ['month_start_date', 'net_paid_amount'],
        #     page: { limit: 50, starting_after: 'abc123' }
        #   )
        class MonthlyBusinessMetrics < Base
          class << self
            # Execute a monthly business metrics query
            #
            # @param fields [Array<String>] Fields to return (detail or summary fields)
            # @param filter [Array, nil] Filter criteria (optional)
            # @param group [String, nil] Grouping field (optional)
            # @param sort [Array<String>, nil] Sort order (optional)
            # @param page [Hash, nil] Pagination options (optional)
            # @param total_count [Boolean] Whether to return total count (optional)
            # @return [Hash] Query result with rows, fields, and metadata
            #
            # @see https://developer.pike13.com/docs/api/v3/reports/monthly-business-metrics
            def query(fields:, filter: nil, group: nil, sort: nil, page: nil, total_count: nil)
              query_params = { fields: fields }
              query_params[:filter] = filter if filter
              query_params[:group] = group if group
              query_params[:sort] = sort if sort
              query_params[:page] = page if page
              query_params[:total_count] = total_count if total_count

              super("monthly_business_metrics", query_params)
            end

            # Available detail fields (when not grouping)
            DETAIL_FIELDS = %w[
              appointment_count
              attendance_completed_count
              business_id
              business_name
              business_subdomain
              class_count
              client_booked_count
              client_completed_enrollment_count
              client_w_plan_count
              completed_appointment_enrollment_count
              completed_class_enrollment_count
              completed_course_enrollment_count
              completed_enrollment_count
              completed_enrollment_per_client
              completed_unpaid_count
              course_count
              currency_code
              due_invoice_count
              enrollment_count
              event_occurrence_count
              event_occurrence_organizer_count
              expected_amount
              expired_enrollment_count
              failed_transaction_count
              first_visit_count
              franchise_id
              key
              late_canceled_enrollment_count
              member_count
              membership_count
              month_start_date
              net_paid_amount
              net_paid_pass_revenue_amount
              net_paid_prepaid_revenue_amount
              net_paid_recurring_revenue_amount
              net_paid_retail_revenue_amount
              net_paid_revenue_amount
              new_client_count
              new_client_w_plan_count
              new_member_count
              new_staff_count
              noshowed_enrollment_count
              outstanding_amount
              pack_count
              payments_amount
              plan_end_count
              plan_start_count
              prepaid_count
              refunds_amount
              registered_enrollment_count
              removed_enrollment_count
              reserved_enrollment_count
              waiting_enrollment_count
            ].freeze

            # Available summary fields (when grouping)
            SUMMARY_FIELDS = %w[
              avg_client_completed_enrollment_count
              avg_client_w_plan_count
              avg_member_count
              business_id_summary
              business_subdomain_summary
              monthly_business_count
              total_attendance_completed_count
              total_completed_enrollment_count
              total_count
              total_enrollment_count
              total_event_occurrence_count
              total_first_visit_count
              total_net_paid_amount
              total_net_paid_revenue_amount
              total_new_client_count
              total_new_client_w_plan_count
              total_new_member_count
              total_payments_amount
              total_refunds_amount
            ].freeze

            # Available grouping fields
            GROUPINGS = %w[
              business_id
              business_name
              business_subdomain
              currency_code
              quarter_start_date
              year_start_date
            ].freeze
          end
        end
      end
    end
  end
end
