# frozen_string_literal: true

module Pike13
  module API
    module V3
      module Desk
        # Pays resource
        # Details of staff member pay, pay rates, services, and hours
        #
        # @example Basic query
        #   Pike13::Reporting::Pays.query(
        #     fields: ['pay_id', 'staff_name', 'pay_type', 'final_pay_amount', 'pay_state']
        #   )
        #
        # @example Query by staff member
        #   Pike13::Reporting::Pays.query(
        #     fields: ['staff_name', 'service_name', 'service_date', 'final_pay_amount', 'service_hours'],
        #     filter: ['eq', 'staff_id', 12345]
        #   )
        #
        # @example Group by staff member
        #   Pike13::Reporting::Pays.query(
        #     fields: ['pay_count', 'total_final_pay_amount', 'total_service_hours'],
        #     group: 'staff_name'
        #   )
        class Pays < Base
          class << self
            # Execute a pays query
            #
            # @param fields [Array<String>] Fields to return (detail or summary fields)
            # @param filter [Array, nil] Filter criteria (optional)
            # @param group [String, nil] Grouping field (optional)
            # @param sort [Array<String>, nil] Sort order (optional)
            # @param page [Hash, nil] Pagination options (optional)
            # @param total_count [Boolean] Whether to return total count (optional)
            # @return [Hash] Query result with rows, fields, and metadata
            #
            # @see https://developer.pike13.com/docs/api/v3/reports/pays
            def query(fields:, filter: nil, group: nil, sort: nil, page: nil, total_count: nil)
              query_params = { fields: fields }
              query_params[:filter] = filter if filter
              query_params[:group] = group if group
              query_params[:sort] = sort if sort
              query_params[:page] = page if page
              query_params[:total_count] = total_count if total_count

              super("pays", query_params)
            end

            # Available detail fields (when not grouping)
            DETAIL_FIELDS = %w[
              base_pay_amount
              business_id
              business_name
              business_subdomain
              currency_code
              final_pay_amount
              franchise_id
              key
              pay_description
              pay_id
              pay_period
              pay_period_end_date
              pay_period_start_date
              pay_recorded_at
              pay_reviewed_at
              pay_reviewed_by_id
              pay_reviewed_by_name
              pay_reviewed_date
              pay_state
              pay_type
              per_head_pay_amount
              revenue_category
              service_category
              service_date
              service_hours
              service_id
              service_location_name
              service_name
              service_type
              staff_home_location_name
              staff_id
              staff_name
              tiered_pay_amount
            ].freeze

            # Available summary fields (when grouping)
            SUMMARY_FIELDS = %w[
              business_id_summary
              business_subdomain_summary
              pay_count
              service_count
              total_base_pay_amount
              total_count
              total_final_pay_amount
              total_per_head_pay_amount
              total_service_hours
              total_tiered_pay_amount
            ].freeze

            # Available grouping fields
            GROUPINGS = %w[
              business_id
              business_name
              business_subdomain
              pay_period
              pay_reviewed_by_id
              pay_reviewed_by_name
              pay_reviewed_date
              pay_state
              pay_type
              revenue_category
              service_category
              service_date
              service_id
              service_location_name
              service_name
              service_type
              staff_home_location_name
              staff_id
              staff_name
            ].freeze
          end
        end
      end
    end
  end
end
