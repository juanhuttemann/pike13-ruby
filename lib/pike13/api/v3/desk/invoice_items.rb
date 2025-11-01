# frozen_string_literal: true

module Pike13
  module API
    module V3
      module Desk
        # Invoice Items resource
        # Item-level details of invoices
        #
        # @example Basic query
        #   Pike13::Reporting::InvoiceItems.query(
        #     fields: ['invoice_item_id', 'invoice_number', 'product_name', 'expected_amount', 'invoice_state']
        #   )
        #
        # @example Query by product type
        #   Pike13::Reporting::InvoiceItems.query(
        #     fields: ['product_name', 'product_type', 'expected_amount', 'net_paid_amount'],
        #     filter: ['eq', 'product_type', 'recurring']
        #   )
        #
        # @example Group by product
        #   Pike13::Reporting::InvoiceItems.query(
        #     fields: ['invoice_item_count', 'total_expected_amount', 'total_net_paid_amount'],
        #     group: 'product_name'
        #   )
        class InvoiceItems < Base
          class << self
            # Execute an invoice items query
            #
            # @param fields [Array<String>] Fields to return (detail or summary fields)
            # @param filter [Array, nil] Filter criteria (optional)
            # @param group [String, nil] Grouping field (optional)
            # @param sort [Array<String>, nil] Sort order (optional)
            # @param page [Hash, nil] Pagination options (optional)
            # @param total_count [Boolean] Whether to return total count (optional)
            # @return [Hash] Query result with rows, fields, and metadata
            #
            # @see https://developer.pike13.com/docs/api/v3/reports/invoice-items
            def query(fields:, filter: nil, group: nil, sort: nil, page: nil, total_count: nil)
              query_params = { fields: fields }
              query_params[:filter] = filter if filter
              query_params[:group] = group if group
              query_params[:sort] = sort if sort
              query_params[:page] = page if page
              query_params[:total_count] = total_count if total_count

              super("invoice_items", query_params)
            end

            # Available detail fields (when not grouping)
            DETAIL_FIELDS = %w[
              adjustments_amount
              business_id
              business_name
              business_subdomain
              closed_at
              closed_date
              commission_recipient_name
              coupon_code
              coupons_amount
              created_by_client
              created_by_name
              currency_code
              days_since_invoice_due
              discount_type
              discounts_amount
              expected_amount
              expected_revenue_amount
              expected_tax_amount
              failed_transactions
              franchise_id
              grants_membership
              gross_amount
              invoice_autobill
              invoice_due_date
              invoice_id
              invoice_item_id
              invoice_number
              invoice_payer_email
              invoice_payer_home_location
              invoice_payer_id
              invoice_payer_name
              invoice_payer_phone
              invoice_payer_primary_staff_name_at_sale
              invoice_state
              issued_at
              issued_date
              key
              net_paid_amount
              net_paid_revenue_amount
              net_paid_tax_amount
              outstanding_amount
              outstanding_revenue_amount
              outstanding_tax_amount
              payments_amount
              plan_id
              product_id
              product_name
              product_name_at_sale
              product_type
              purchase_order_number
              purchase_request_cancel_reason
              purchase_request_message
              purchase_request_state
              recipient_names
              refunded_transactions
              refunds_amount
              retail_add_ons
              retail_options
              revenue_category
              sale_location_name
              tax_types
              tax_types_extended
              voided_transactions
            ].freeze

            # Available summary fields (when grouping)
            SUMMARY_FIELDS = %w[
              business_id_summary
              business_subdomain_summary
              grants_membership_count
              invoice_count
              invoice_item_count
              total_adjustments_amount
              total_count
              total_coupons_amount
              total_discounts_amount
              total_expected_amount
              total_expected_revenue_amount
              total_expected_tax_amount
              total_gross_amount
              total_net_paid_amount
              total_net_paid_revenue_amount
              total_net_paid_tax_amount
              total_outstanding_amount
              total_outstanding_revenue_amount
              total_outstanding_tax_amount
              total_payments_amount
              total_refunds_amount
            ].freeze

            # Available grouping fields
            GROUPINGS = %w[
              business_id
              business_name
              business_subdomain
              closed_date
              closed_month_start_date
              closed_quarter_start_date
              closed_week_mon_start_date
              closed_week_sun_start_date
              closed_year_start_date
              commission_recipient_name
              coupon_code
              created_by_client
              created_by_name
              discount_type
              due_month_start_date
              due_quarter_start_date
              due_week_mon_start_date
              due_week_sun_start_date
              due_year_start_date
              grants_membership
              invoice_autobill
              invoice_due_date
              invoice_id
              invoice_number
              invoice_payer_home_location
              invoice_payer_id
              invoice_payer_name
              invoice_payer_primary_staff_name_at_sale
              invoice_state
              issued_date
              issued_month_start_date
              issued_quarter_start_date
              issued_week_mon_start_date
              issued_week_sun_start_date
              issued_year_start_date
              plan_id
              product_id
              product_name
              product_name_at_sale
              product_type
              purchase_request_state
              revenue_category
              sale_location_name
            ].freeze
          end
        end
      end
    end
  end
end
