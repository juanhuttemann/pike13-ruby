# frozen_string_literal: true

module Pike13
  module API
    module V2
      module Account
        class Business < Base
          class << self
            # GET /account/businesses
            def all
              client.get("account/businesses")
            end

          end
        end
      end
    end
  end
end
