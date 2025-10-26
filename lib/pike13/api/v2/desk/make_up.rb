# frozen_string_literal: true

module Pike13
  module API
    module V2
      module Desk
        class MakeUp < Base
          uri "desk/make_ups(/:id)"

          # Get make up reasons
          #
          # @return [Array<Hash>] Make up reasons
          #
          # @example
          #   reasons = Pike13::API::V2::Desk::MakeUp.reasons
          def self.reasons
            with("desk/make_ups/reasons").to_a
          end

          # Generate make up pass
          #
          # @param visit_id [Integer] Visit ID (required)
          # @param make_up_reason_id [Integer] Make up reason ID (required)
          # @param free_form_reason [String] Optional free-form reason
          # @return [Hash] Make up data
          #
          # @example
          #   make_up = Pike13::API::V2::Desk::MakeUp.generate(
          #     visit_id: 123,
          #     make_up_reason_id: 1,
          #     free_form_reason: "Student was ill"
          #   )
          def self.generate(visit_id:, make_up_reason_id:, free_form_reason: nil)
            body = {
              visit_id: visit_id,
              make_up: {
                make_up_reason_id: make_up_reason_id
              }
            }
            body[:make_up][:free_form_reason] = free_form_reason if free_form_reason

            request(:post, "desk/make_ups/generate", body).data
          end
        end
      end
    end
  end
end
