# frozen_string_literal: true

module Pike13
  module API
    module V3
      module Desk
        # Person Plans resource
        # Comprehensive data about passes and plans that are available for use or on hold
        #
        # @example Basic query
        #   Pike13::Reporting::PersonPlans.query(
        #     fields: ['person_plan_id', 'full_name', 'plan_name', 'is_available', 'start_date']
        #   )
        #
        # @example Query available memberships
        #   Pike13::Reporting::PersonPlans.query(
        #     fields: ['full_name', 'plan_name', 'start_date', 'end_date', 'remaining_visit_count'],
        #     filter: [
        #       'and',
        #       [
        #         ['eq', 'is_available', true],
        #         ['eq', 'grants_membership', true]
        #       ]
        #     ]
        #   )
        #
        # @example Group by plan type
        #   Pike13::Reporting::PersonPlans.query(
        #     fields: ['person_plan_count', 'is_available_count', 'is_on_hold_count'],
        #     group: 'plan_type'
        #   )
        class PersonPlans < Base
          class << self
            # Execute a person plans query
            #
            # @param fields [Array<String>] Fields to return (detail or summary fields)
            # @param filter [Array, nil] Filter criteria (optional)
            # @param group [String, nil] Grouping field (optional)
            # @param sort [Array<String>, nil] Sort order (optional)
            # @param page [Hash, nil] Pagination options (optional)
            # @param total_count [Boolean] Whether to return total count (optional)
            # @return [Hash] Query result with rows, fields, and metadata
            #
            # @see https://developer.pike13.com/docs/api/v3/reports/person-plans
            def query(fields:, filter: nil, group: nil, sort: nil, page: nil, total_count: nil)
              query_params = { fields: fields }
              query_params[:filter] = filter if filter
              query_params[:group] = group if group
              query_params[:sort] = sort if sort
              query_params[:page] = page if page
              query_params[:total_count] = total_count if total_count

              super("person_plans", query_params)
            end

            # Available detail fields (when not grouping)
            DETAIL_FIELDS = %w[
              account_manager_emails
              account_manager_names
              account_manager_phones
              allowed_visit_count
              are_visits_shared
              base_price
              business_id
              business_name
              business_subdomain
              canceled_at
              canceled_by
              canceled_by_account_id
              cancellation_fee_amount
              charged_cancellation_fee_amount
              commitment_length
              completed_visit_count
              currency_code
              deactivated_at
              email
              end_date
              exhausted_at
              first_name
              first_visit_date
              first_visit_day
              first_visit_instructor_names
              first_visit_time
              first_visit_to_next_plan
              franchise_id
              full_name
              grants_membership
              has_cancellation_fee
              home_location_name
              invoice_interval_count
              invoice_interval_unit
              is_available
              is_canceled
              is_cancellation_fee_charged
              is_complimentary_pass
              is_deactivated
              is_deleted
              is_ended
              is_exhausted
              is_first_membership
              is_first_plan
              is_last_hold_indefinite
              is_on_hold
              is_primary_participant
              key
              last_hold_by
              last_hold_by_account_id
              last_hold_end_date
              last_hold_start_date
              last_name
              last_usable_date
              last_visit_date
              last_visit_day
              last_visit_time
              last_visit_to_next_plan
              latest_invoice_autobill
              latest_invoice_due_date
              latest_invoice_item_amount
              latest_invoice_past_due
              lifetime_used_visit_count
              middle_name
              next_plan_grants_membership
              next_plan_id
              next_plan_name
              next_plan_revenue_category
              next_plan_start_date
              next_plan_type
              person_id
              person_plan_id
              plan_id
              plan_location_id
              plan_location_name
              plan_name
              plan_product_id
              plan_type
              primary_staff_name
              product_id
              product_name
              remaining_commitment
              remaining_visit_count
              revenue_category
              rollover_count
              start_date
              start_date_to_first_visit
              start_date_to_next_plan
              stop_renewing_after_commitment
              term_acceptance_required
              term_accepted
              used_for_initial_visit
              used_visit_count
              visit_refresh_interval_count
              visit_refresh_interval_unit
            ].freeze

            # Available summary fields (when grouping)
            SUMMARY_FIELDS = %w[
              avg_first_visit_to_next_plan
              avg_last_visit_to_next_plan
              avg_start_date_to_first_visit
              avg_start_date_to_next_plan
              business_id_summary
              business_subdomain_summary
              grants_membership_count
              has_cancellation_fee_count
              is_available_count
              is_canceled_count
              is_complimentary_pass_count
              is_first_membership_count
              is_first_plan_count
              is_on_hold_count
              latest_invoice_past_due_count
              next_plan_count
              next_plan_grants_membership_percent
              next_plan_on_visit_date_percent
              next_plan_out_of_visited_percent
              next_plan_percent
              next_plan_within_week_percent
              person_count
              person_plan_count
              plan_count
              total_cancellation_fee_amount
              total_charged_cancellation_fee_amount
              total_count
              total_latest_invoice_item_amount
              total_lifetime_used_visit_count
              total_used_for_initial_visit
              total_used_visit_count
              visited_count
              visited_percent
            ].freeze

            # Available grouping fields
            GROUPINGS = %w[
              are_visits_shared
              business_id
              business_name
              business_subdomain
              canceled_by
              canceled_by_account_id
              end_date
              first_visit_date
              first_visit_instructor_names
              first_visit_month_start_date
              first_visit_quarter_start_date
              first_visit_week_mon_start_date
              first_visit_week_sun_start_date
              first_visit_year_start_date
              full_name
              grants_membership
              has_cancellation_fee
              home_location_name
              is_available
              is_canceled
              is_cancellation_fee_charged
              is_complimentary_pass
              is_deleted
              is_first_membership
              is_first_plan
              is_last_hold_indefinite
              is_on_hold
              last_hold_by
              last_hold_by_account_id
              last_hold_end_date
              last_hold_start_date
              last_usable_date
              last_usable_month_start_date
              last_usable_quarter_start_date
              last_usable_week_mon_start_date
              last_usable_week_sun_start_date
              last_usable_year_start_date
              last_visit_date
              last_visit_month_start_date
              last_visit_quarter_start_date
              last_visit_week_mon_start_date
              last_visit_week_sun_start_date
              last_visit_year_start_date
              latest_invoice_autobill
              latest_invoice_due_date
              latest_invoice_past_due
              person_id
              plan_id
              plan_location_id
              plan_location_name
              plan_name
              plan_product_id
              plan_type
              primary_staff_name
              product_id
              product_name
              revenue_category
              start_date
              start_month_start_date
              start_quarter_start_date
              start_week_mon_start_date
              start_week_sun_start_date
              start_year_start_date
              stop_renewing_after_commitment
              used_for_initial_visit
            ].freeze
          end
        end
      end
    end
  end
end
