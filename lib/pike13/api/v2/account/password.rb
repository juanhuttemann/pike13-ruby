# frozen_string_literal: true

module Pike13
  module API
    module V2
      module Account
        class Password < Base
          class << self
            # POST /account/passwords
            def create(attributes)
              client.post("account/passwords", { account: attributes })
            end
          end
        end
      end
    end
  end
end
