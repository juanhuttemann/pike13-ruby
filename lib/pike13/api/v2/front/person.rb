# frozen_string_literal: true

module Pike13
  module API
    module V2
      module Front
        class Person < Pike13::API::V2::Base
          include Pike13::API::V2::PersonMethods

          @scope = "front"
          @resource_name = "people"

          # The Pike13 API does not support listing people in the front namespace
          # Only the authenticated user's information is available
          #
          # @raise [NotImplementedError] Always raises as this endpoint doesn't exist
          def self.all(session:, **params)
            raise NotImplementedError,
                  "The Pike13 API does not support listing people in the front namespace. " \
                  "Use client.front.people.me to retrieve the authenticated user."
          end

          # The Pike13 API does not support counting people in the front namespace
          #
          # @raise [NotImplementedError] Always raises as this endpoint doesn't exist
          def self.count(session:, **params)
            raise NotImplementedError,
                  "The Pike13 API does not support counting people in the front namespace."
          end

          # Nested resource methods using has_many DSL
          has_many :visits
          has_many :waitlist_entries
        end
      end
    end
  end
end
