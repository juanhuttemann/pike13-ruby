# frozen_string_literal: true

module Pike13
  module API
    module V2
      module Front
        class Payment < Base
          class << self
            # GET /front/payments/:id
            def find(id)
              client.get("front/payments/#{id}")
            end

            # GET /front/payments/configuration
            def configuration
              client.get("front/payments/configuration")
            end
          end
        end
      end
    end
  end
end
