# frozen_string_literal: true

module Pike13
  module API
    module V2
      module Account
        class Person < Pike13::API::V2::Base
          @resource_name = "people"

          # Override the default all method to work with account scope
          def self.all(client:, **params)
            path = "/account/people"
            response = client.get(path, params: params)
            data = response["people"] || []
            data.map { |item| new(client: client, **item.transform_keys(&:to_sym)) }
          end
        end
      end
    end
  end
end
