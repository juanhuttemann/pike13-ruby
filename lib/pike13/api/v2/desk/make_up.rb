# frozen_string_literal: true

module Pike13
  module API
    module V2
      module Desk
        class MakeUp < Spyke::Base
          uri "desk/make_ups(/:id)"

          class << self
            # Get make up reasons
            #
            # @param client [Pike13::Client] Client instance
            # @return [Array<Hash>] Make up reasons
            #
            # @example
            #   reasons = Pike13::API::V2::Desk::MakeUp.reasons(client: client)
            def reasons(client:)
              response = client.get("/desk/make_ups/reasons")
              response["make_up_reasons"] || []
            end

            # Generate make up pass
            #
            # @param client [Pike13::Client] Client instance
            # @param visit_id [Integer] Visit ID (required)
            # @param make_up_reason_id [Integer] Make up reason ID (required)
            # @param free_form_reason [String] Optional free-form reason
            # @return [Hash] Make up data
            #
            # @example
            #   make_up = Pike13::API::V2::Desk::MakeUp.generate(
            #     client: client,
            #     visit_id: 123,
            #     make_up_reason_id: 1,
            #     free_form_reason: "Student was ill"
            #   )
            def generate(client:, visit_id:, make_up_reason_id:, free_form_reason: nil)
              body = {
                visit_id: visit_id,
                make_up: {
                  make_up_reason_id: make_up_reason_id
                }
              }
              body[:make_up][:free_form_reason] = free_form_reason if free_form_reason

              response = client.post("/desk/make_ups/generate", body: body)
              response["make_up"] || {}
            end
          end
        end
      end
    end
  end
end
