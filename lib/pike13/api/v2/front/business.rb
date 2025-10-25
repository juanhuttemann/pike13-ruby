# frozen_string_literal: true

module Pike13
  module API
    module V2
      module Front
        class Business < Spyke::Base
          uri "front/business"
          include_root_in_json :business
        end
      end
    end
  end
end
