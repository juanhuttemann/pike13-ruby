# frozen_string_literal: true

module Pike13
  module API
    module V3
      module Desk
        # Clients resource
        # All client data — from tenure and unpaid bills to birthdays and passes held
        #
        # @example Basic query
        #   Pike13::Reporting::Clients.query(
        #     fields: ['person_id', 'full_name', 'email', 'client_since_date']
        #   )
        #
        # @example Query with filters
        #   Pike13::Reporting::Clients.query(
        #     fields: ['full_name', 'email', 'tenure', 'has_membership'],
        #     filter: ['eq', 'has_membership', true]
        #   )
        #
        # @example Query with grouping
        #   Pike13::Reporting::Clients.query(
        #     fields: ['person_count', 'has_membership_count'],
        #     group: 'tenure_group'
        #   )
        class Clients < Base
          class << self
            # Execute a clients query
            #
            # @param fields [Array<String>] Fields to return (detail or summary fields)
            # @param filter [Array, nil] Filter criteria (optional)
            # @param group [String, nil] Grouping field (optional)
            # @param sort [Array<String>, nil] Sort order (optional)
            # @param page [Hash, nil] Pagination options (optional)
            # @param total_count [Boolean] Whether to return total count (optional)
            # @return [Hash] Query result with rows, fields, and metadata
            #
            # @see https://developer.pike13.com/docs/api/v3/reports/clients
            def query(fields:, filter: nil, group: nil, sort: nil, page: nil, total_count: nil)
              query_params = { fields: fields }
              query_params[:filter] = filter if filter
              query_params[:group] = group if group
              query_params[:sort] = sort if sort
              query_params[:page] = page if page
              query_params[:total_count] = total_count if total_count

              super("clients", query_params)
            end

            # Available detail fields (when not grouping)
            DETAIL_FIELDS = %w[
              account_claim_date
              account_credit_amount
              account_manager_emails
              account_manager_names
              account_manager_phones
              address
              street_address
              street_address2
              city
              state_code
              postal_code
              country_code
              age
              also_staff
              birthdate
              business_id
              business_name
              business_subdomain
              client_since_date
              completed_visits
              currency_code
              current_plan_revenue_category
              current_plan_types
              current_plans
              custom_fields
              days_since_last_visit
              days_until_birthday
              dependent_names
              email
              first_name
              first_visit_date
              franchise_id
              full_name
              future_visits
              guardian_email
              guardian_name
              has_membership
              has_payment_on_file
              has_plan_on_hold
              has_signed_waiver
              home_location_name
              is_schedulable
              key
              last_email_bounced
              last_invoice_amount
              last_invoice_date
              last_invoice_id
              last_invoice_unpaid
              last_membership_end_date
              last_name
              last_signed_waiver_name
              last_site_access_date
              last_visit_date
              last_visit_id
              last_visit_service
              middle_name
              net_paid_amount
              next_pass_plan_end_date
              person_id
              person_state
              phone
              primary_staff_name
              revenue_amount
              source_name
              staff_member_who_added
              tenure
              tenure_group
              unpaid_visits
            ].freeze

            # Available summary fields (when grouping)
            SUMMARY_FIELDS = %w[
              account_claim_count
              also_staff_count
              business_id_summary
              business_subdomain_summary
              has_membership_count
              has_payment_on_file_count
              has_plan_on_hold_count
              has_signed_waiver_count
              is_schedulable_count
              last_email_bounced_count
              last_invoice_unpaid_count
              person_count
              total_account_credit_amount
              total_completed_visits
              total_count
              total_future_visits
              total_net_paid_amount
              total_revenue_amount
              total_unpaid_visits
              visited_site_count
            ].freeze

            # Available grouping fields
            GROUPINGS = %w[
              account_claim_date
              account_manager_names
              age
              also_staff
              business_id
              business_name
              business_subdomain
              client_since_date
              client_since_month_start_date
              client_since_quarter_start_date
              client_since_week_mon_start_date
              client_since_week_sun_start_date
              client_since_year_start_date
              has_membership
              has_payment_on_file
              has_plan_on_hold
              has_signed_waiver
              home_location_name
              is_schedulable
              last_email_bounced
              last_invoice_unpaid
              person_state
              primary_staff_name
              source_name
              staff_member_who_added
              tenure_group
            ].freeze
          end
        end
      end
    end
  end
end
