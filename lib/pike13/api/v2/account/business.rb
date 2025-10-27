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

            # GET /account/businesses/:id
            def find(id)
              client.get("account/businesses/#{id}")
            end
          end
        end
      end
    end
  end
end
