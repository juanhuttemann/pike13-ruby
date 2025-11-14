# frozen_string_literal: true

module Pike13
  module API
    module V2
      module Desk
        class CustomField < Base
          class << self
            # GET /desk/custom_fields
            def all
              client.get("desk/custom_fields")
            end
          end
        end
      end
    end
  end
end
