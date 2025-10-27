# frozen_string_literal: true

module Pike13
  module API
    module V2
      module Account
        class Person < Base
          class << self
            # GET /account/people
            def all
              client.get("account/people")
            end
          end
        end
      end
    end
  end
end
