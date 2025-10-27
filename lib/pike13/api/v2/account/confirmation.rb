# frozen_string_literal: true

module Pike13
  module API
    module V2
      module Account
        class Confirmation < Base
          class << self
            # POST /account/confirmations
            def create(attributes)
              client.post("account/confirmations", { account: attributes })
            end
          end
        end
      end
    end
  end
end
