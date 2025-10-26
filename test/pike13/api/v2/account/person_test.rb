# frozen_string_literal: true

require "test_helper"

module Pike13
  module API
    module V2
      module Account
        class PersonTest < Minitest::Test
          def setup
            setup_pike13
          end

          # NOTE: /account/people/me endpoint does not exist in the API
          # Only /account/people (all) is available
        end
      end
    end
  end
end
