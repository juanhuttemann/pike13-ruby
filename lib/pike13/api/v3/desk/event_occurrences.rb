# frozen_string_literal: true

module Pike13
  module API
    module V3
      module Desk
        # Event Occurrences resource
        # Data about scheduled instances of services (e.g., "Group Workout from 9am-10am on 2024/09/01")
        #
        # @example Basic query
        #   Pike13::Reporting::EventOccurrences.query(
        #     fields: ['event_occurrence_id', 'event_name', 'service_date', 'enrollment_count', 'capacity']
        #   )
        #
        # @example Query high attendance classes
        #   Pike13::Reporting::EventOccurrences.query(
        #     fields: ['event_name', 'service_date', 'completed_enrollment_count', 'capacity'],
        #     filter: ['gt', 'completed_enrollment_count', 15],
        #     sort: ['completed_enrollment_count-']
        #   )
        #
        # @example Group by service name
        #   Pike13::Reporting::EventOccurrences.query(
        #     fields: ['total_enrollment_count', 'total_completed_enrollment_count', 'total_noshowed_enrollment_count'],
        #     group: 'service_name'
        #   )
        class EventOccurrences < Base
          class << self
            # Execute an event occurrences query
            #
            # @param fields [Array<String>] Fields to return (detail or summary fields)
            # @param filter [Array, nil] Filter criteria (optional)
            # @param group [String, nil] Grouping field (optional)
            # @param sort [Array<String>, nil] Sort order (optional)
            # @param page [Hash, nil] Pagination options (optional)
            # @param total_count [Boolean] Whether to return total count (optional)
            # @return [Hash] Query result with rows, fields, and metadata
            #
            # @see https://developer.pike13.com/docs/api/v3/reports/event-occurrences
            def query(fields:, filter: nil, group: nil, sort: nil, page: nil, total_count: nil)
              query_params = { fields: fields }
              query_params[:filter] = filter if filter
              query_params[:group] = group if group
              query_params[:sort] = sort if sort
              query_params[:page] = page if page
              query_params[:total_count] = total_count if total_count

              super("event_occurrences", query_params)
            end

            # Available detail fields (when not grouping)
            DETAIL_FIELDS = %w[
              attendance_completed
              business_id
              business_name
              business_subdomain
              capacity
              completed_enrollment_count
              completed_unpaid_count
              currency_code
              duration_in_hours
              duration_in_minutes
              end_at
              enrollment_count
              event_id
              event_name
              event_occurrence_id
              expired_enrollment_count
              franchise_id
              instructor_names
              is_waitlist_count
              key
              late_canceled_enrollment_count
              noshowed_enrollment_count
              paid_count
              registered_enrollment_count
              removed_enrollment_count
              reserved_enrollment_count
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
              visit_count
              waiting_enrollment_count
              waitlist_to_visit_count
            ].freeze

            # Available summary fields (when grouping)
            SUMMARY_FIELDS = %w[
              attendance_completed_count
              business_id_summary
              business_subdomain_summary
              event_count
              event_occurrence_count
              service_count
              total_capacity
              total_completed_enrollment_count
              total_completed_unpaid_count
              total_count
              total_duration_in_hours
              total_duration_in_minutes
              total_enrollment_count
              total_expired_enrollment_count
              total_is_waitlist_count
              total_late_canceled_enrollment_count
              total_noshowed_enrollment_count
              total_paid_count
              total_registered_enrollment_count
              total_removed_enrollment_count
              total_reserved_enrollment_count
              total_visit_count
              total_waiting_enrollment_count
              total_waitlist_to_visit_count
            ].freeze

            # Available grouping fields
            GROUPINGS = %w[
              attendance_completed
              business_id
              business_name
              business_subdomain
              event_id
              event_name
              event_occurrence_id
              instructor_names
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
            ].freeze
          end
        end
      end
    end
  end
end
