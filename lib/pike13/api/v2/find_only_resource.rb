# frozen_string_literal: true

module Pike13
  module API
    module V2
      # Base class for resources that can only be retrieved by ID
      # and don't support listing all records or counting.
      #
      # Examples: Booking, Pack, Punch, Invoice (front), WaitlistEntry (front)
      class FindOnlyResource < Base
        def self.all(session:, **params)
          raise NotImplementedError,
                "The Pike13 API does not support listing all #{resource_name}. " \
                "Use client.#{scope}.#{resource_name}.find(id: ...) to retrieve a specific resource."
        end

        def self.count(session:, **params)
          raise NotImplementedError,
                "The Pike13 API does not support counting #{resource_name}."
        end
      end
    end
  end
end
