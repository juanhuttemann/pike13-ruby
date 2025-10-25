# frozen_string_literal: true

module Pike13
  module API
    module V2
      module Front
        class Branding < Spyke::Base
          uri "front/branding"
          include_root_in_json :branding
        end
      end
    end
  end
end
