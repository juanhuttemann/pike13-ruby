# frozen_string_literal: true

module Pike13
  module API
    module V2
      module Account
        class Business < Spyke::Base
          uri "account/businesses(/:id)"
          include_root_in_json :business
        end
      end
    end
  end
end
