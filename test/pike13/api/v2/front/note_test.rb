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

          # Front API Notes are read-only (no POST/PUT/DELETE methods)
        end
      end
    end
  end
end
