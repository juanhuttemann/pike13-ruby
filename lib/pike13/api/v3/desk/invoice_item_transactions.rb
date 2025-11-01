# frozen_string_literal: true

module Pike13
  module API
    module V3
      module Desk
        # Invoice Item Transactions resource
        # Item-level details of transactions (payments and refunds)
        # Payments and refunds are performed against the invoice, not the invoice item
        #
        # @example Basic query
        #   Pike13::Reporting::InvoiceItemTransactions.query(
        #     fields: ['transaction_id', 'invoice_number', 'transaction_type', 'transaction_amount', 'transaction_state']
        #   )
        #
        # @example Query by payment method
        #   Pike13::Reporting::InvoiceItemTransactions.query(
        #     fields: ['transaction_date', 'payment_method', 'transaction_amount', 'invoice_payer_name'],
        #     filter: ['eq', 'payment_method', 'creditcard']
        #   )
        #
        # @example Group by payment method
        #   Pike13::Reporting::InvoiceItemTransactions.query(
        #     fields: ['transaction_count', 'total_net_paid_amount', 'settled_count'],
        #     group: 'payment_method'
        #   )
        class InvoiceItemTransactions < Base
          class << self
            # Execute an invoice item transactions query
            #
            # @param fields [Array<String>] Fields to return (detail or summary fields)
            # @param filter [Array, nil] Filter criteria (optional)
            # @param group [String, nil] Grouping field (optional)
            # @param sort [Array<String>, nil] Sort order (optional)
            # @param page [Hash, nil] Pagination options (optional)
            # @param total_count [Boolean] Whether to return total count (optional)
            # @return [Hash] Query result with rows, fields, and metadata
            #
            # @see https://developer.pike13.com/docs/api/v3/reports/invoice-item-transactions
            def query(fields:, filter: nil, group: nil, sort: nil, page: nil, total_count: nil)
              query_params = { fields: fields }
              query_params[:filter] = filter if filter
              query_params[:group] = group if group
              query_params[:sort] = sort if sort
              query_params[:page] = page if page
              query_params[:total_count] = total_count if total_count

              super("invoice_item_transactions", query_params)
            end

            # Available detail fields (when not grouping)
            DETAIL_FIELDS = %w[
              business_id
              business_name
              business_subdomain
              commission_recipient_name
              created_by_name
              credit_card_name
              currency_code
              error_message
              external_payment_name
              failed_at
              failed_date
              franchise_id
              grants_membership
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
              key
              net_paid_amount
              net_paid_revenue_amount
              net_paid_tax_amount
              payment_method
              payment_method_detail
              payment_transaction_id
              payments_amount
              plan_id
              processing_method
              processor_transaction_id
              product_id
              product_name
              product_name_at_sale
              product_type
              refunds_amount
              revenue_category
              sale_location_name
              transaction_amount
              transaction_at
              transaction_autopay
              transaction_date
              transaction_id
              transaction_state
              transaction_type
              voided_at
            ].freeze

            # Available summary fields (when grouping)
            SUMMARY_FIELDS = %w[
              business_id_summary
              business_subdomain_summary
              failed_count
              grants_membership_count
              invoice_count
              invoice_item_count
              settled_count
              total_count
              total_net_ach_paid_amount
              total_net_american_express_paid_amount
              total_net_amex_processing_paid_amount
              total_net_cash_paid_amount
              total_net_check_paid_amount
              total_net_credit_paid_amount
              total_net_discover_paid_amount
              total_net_external_paid_amount
              total_net_global_pay_processing_paid_amount
              total_net_mastercard_paid_amount
              total_net_other_credit_card_paid_amount
              total_net_other_processing_paid_amount
              total_net_paid_amount
              total_net_paid_revenue_amount
              total_net_paid_tax_amount
              total_net_visa_paid_amount
              total_payments_amount
              total_refunds_amount
              transaction_autopay_count
              transaction_count
            ].freeze

            # Available grouping fields
            GROUPINGS = %w[
              business_id
              business_name
              business_subdomain
              commission_recipient_name
              created_by_name
              credit_card_name
              external_payment_name
              failed_date
              failed_month_start_date
              failed_quarter_start_date
              failed_week_mon_start_date
              failed_week_sun_start_date
              failed_year_start_date
              grants_membership
              invoice_autobill
              invoice_due_date
              invoice_id
              invoice_item_id
              invoice_number
              invoice_payer_home_location
              invoice_payer_id
              invoice_payer_name
              invoice_payer_primary_staff_name_at_sale
              invoice_state
              payment_method
              plan_id
              processing_method
              product_id
              product_name
              product_name_at_sale
              product_type
              revenue_category
              sale_location_name
              transaction_autopay
              transaction_date
              transaction_id
              transaction_month_start_date
              transaction_quarter_start_date
              transaction_state
              transaction_type
              transaction_week_mon_start_date
              transaction_week_sun_start_date
              transaction_year_start_date
            ].freeze
          end
        end
      end
    end
  end
end
