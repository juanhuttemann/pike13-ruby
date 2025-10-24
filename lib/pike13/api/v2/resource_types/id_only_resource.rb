# frozen_string_literal: true

module Pike13
  module API
    module V2
      # Base class for resources that require an ID to retrieve
      # Does not support listing (.all) or counting (.count)
      #
      # Use this for resources where the Pike13 API only allows
      # direct access by ID - you can't list or search for them.
      #
      # @example Resources using this pattern
      #   - Booking (desk/front) - Must know booking ID
      #   - Pack (desk) - Must know pack ID
      #   - Punch (desk) - Must know punch ID
      #   - Invoice (front only) - Must know invoice ID
      #   - WaitlistEntry (front only) - Must know entry ID
      #
      # @example Usage
      #   booking = client.desk.bookings.find(123)  # ✅ Works
      #   bookings = client.desk.bookings.all       # ❌ NotImplementedError
      class IdOnlyResource < Base
        # Raises NotImplementedError as Pike13 API doesn't support listing
        #
        # @raise [NotImplementedError] Always raised
        def self.all(client:, **params)
          raise NotImplementedError,
                "The Pike13 API does not support listing all #{resource_name}. " \
                "Use client.#{scope}.#{resource_name}.find(id: <id>) to retrieve a specific resource."
        end

        # Raises NotImplementedError as Pike13 API doesn't support counting
        #
        # @raise [NotImplementedError] Always raised
        def self.count(client:, **params)
          raise NotImplementedError,
                "The Pike13 API does not support counting #{resource_name}. " \
                "This resource can only be accessed by ID using .find(id)"
        end
      end
    end
  end
end
