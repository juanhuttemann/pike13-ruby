# frozen_string_literal: true

module Pike13
  module API
    module V2
      # Base class for singleton resources (only one exists per context)
      # These resources don't require an ID - they return the single instance
      #
      # Use this for resources that represent "the current" entity,
      # like "the business" or "the account" in the current context.
      #
      # @example Resources using this pattern
      #   - Business (desk/front) - The current business
      #   - Branding (front) - The current business's branding
      #   - Account (account) - The current account
      #
      # @example Usage
      #   business = client.desk.business.find    # ✅ No ID needed
      #   branding = client.front.branding.find   # ✅ Returns the single resource
      #   businesses = client.desk.business.all   # ❌ NotImplementedError
      class SingletonResource < Base
        # Find the singular resource (no ID required)
        #
        # @param client [Pike13::Client] Client instance
        # @param params [Hash] Optional query parameters
        # @return [Base] Resource instance
        def self.find(client:, **params)
          raise ArgumentError, "client is required" unless client

          path = "/#{scope}/#{resource_name}"
          response = client.get(path, params: params)
          data = extract_resource_data(response)

          new(client: client, **data.transform_keys(&:to_sym))
        end

        # Raises NotImplementedError as singleton resources can't be listed
        #
        # @raise [NotImplementedError] Always raised
        def self.all(client:, **params)
          raise NotImplementedError,
                "#{name} is a singleton resource. Use .find (without an ID) instead of .all"
        end

        # Raises NotImplementedError as singleton resources can't be counted
        #
        # @raise [NotImplementedError] Always raised
        def self.count(client:, **params)
          raise NotImplementedError,
                "#{name} is a singleton resource and cannot be counted."
        end

        # Extract resource data from API response
        # Handles both real API responses (pluralized array) and test stubs (singular key)
        #
        # @param response [Hash] API response
        # @return [Hash] Resource data
        # @private
        def self.extract_resource_data(response)
          # API returns: {"businesses": [{...}]}, {"brandings": [{...}]}
          plural_key = "#{resource_name}s"
          data = response[plural_key]

          if data.is_a?(Array)
            # Real API response: extract first item from array
            data.first || {}
          elsif data.nil?
            # Test stub pattern: {"business": {...}}
            response[resource_name] || {}
          else
            # Unexpected format, return as-is
            data
          end
        end
        private_class_method :extract_resource_data
      end
    end
  end
end
