# frozen_string_literal: true

module Pike13
  module API
    module V2
      module Front
        class Branding < Base
          class << self
            # GET /front/branding
            def get
              client.get("front/branding")
            end
          end
        end
      end
    end
  end
end
