# frozen_string_literal: true

module Pike13
  module API
    module V2
      module Account
        class Confirmation < Base
          uri "account/confirmations(/:id)"
          include_root_in_json :account
        end
      end
    end
  end
end
