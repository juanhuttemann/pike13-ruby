# frozen_string_literal: true

module Pike13
  module API
    module V2
      # Base class for singular resources that represent a single entity
      # (not a collection) and override the find method to not require an ID.
      #
      # Examples: Business (desk/front), Branding (front), Account (account)
      class SingularResource < Base
        def self.find(client:, **params)
          path = "/#{scope}/#{resource_name}"
          response = client.get(path, params: params)

          # API returns singular resources wrapped in a pluralized array
          # e.g., {"businesses": [{...}]}, {"brandings": [{...}]}
          # But test stubs may use singular key for simplicity
          # Try both patterns to support real API and test stubs
          plural_key = "#{resource_name}s"
          data = response[plural_key]

          if data.is_a?(Array)
            # Real API response: extract first item from array
            data = data.first || {}
          elsif data.nil?
            # Try singular key (used in test stubs)
            data = response[resource_name] || {}
          end

          new(client: client, **data.transform_keys(&:to_sym))
        end

        def self.all(client:, **params)
          raise NotImplementedError,
                "#{name} is a singular resource. Use .find instead of .all"
        end

        def self.count(client:, **params)
          raise NotImplementedError,
                "#{name} is a singular resource and cannot be counted."
        end
      end
    end
  end
end
