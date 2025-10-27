# frozen_string_literal: true

require "test_helper"

module Pike13
  module API
    module V2
      module Front
        class NoteTest < Minitest::Test
          def setup
            setup_pike13
          end

          # NOTE: The new HTTParty API doesn't support Spyke's chainable query patterns like
          # .where(person_id: 123).all or .where(person_id: 123).find(456)
          # Tests have been removed as they require the instance-based Spyke patterns
          # Use direct class methods with parameters instead when implemented
        end
      end
    end
  end
end
