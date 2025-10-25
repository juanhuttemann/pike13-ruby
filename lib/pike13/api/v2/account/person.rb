# frozen_string_literal: true

module Pike13
  module API
    module V2
      module Account
        class Person < Spyke::Base
          uri "account/people(/:id)"
          include_root_in_json :person
        end
      end
    end
  end
end
