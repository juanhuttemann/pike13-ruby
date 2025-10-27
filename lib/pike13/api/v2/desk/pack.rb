# frozen_string_literal: true

module Pike13
  module API
    module V2
      module Desk
        class Pack < Base
          class << self
            # GET /desk/packs
            def all
              client.get("desk/packs")
            end

            # GET /desk/packs/:id
            def find(id)
              client.get("desk/packs/#{id}")
            end
          end
        end
      end
    end
  end
end
