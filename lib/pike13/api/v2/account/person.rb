# frozen_string_literal: true

module Pike13
  module API
    module V2
      module Account
        class Person < Pike13::API::V2::Base
          @scope = "account"
          @resource_name = "people"

          # Override the default all method to work with account scope
          def self.all(session:, **params)
            path = "/account/people"
            response = session.http_client.get(path, params: params, scoped: false)
            data = response["people"] || []
            data.map { |item| new(session: session, **item.transform_keys(&:to_sym)) }
          end
        end
      end
    end
  end
end
