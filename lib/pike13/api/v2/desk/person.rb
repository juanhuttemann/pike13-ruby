# frozen_string_literal: true

module Pike13
  module API
    module V2
      module Desk
        class Person < Pike13::API::V2::Base
          include Pike13::API::V2::PersonMethods

          @resource_name = "people"

          # Nested resource methods using has_many DSL
          has_many :plans
          has_many :waivers
          has_many :form_of_payments
          has_many :notes
          has_many :waitlist_entries

          # Get visits for this person
          # Custom implementation since visits use a different pattern
          #
          # @param params [Hash] Optional query parameters (from, to, event_occurrence_id)
          # @return [Array<Pike13::API::V2::Desk::Visit>]
          def visits(**params)
            Pike13::API::V2::Desk::Visit.all(person_id: id, client: client, **params)
          end
        end
      end
    end
  end
end
