# frozen_string_literal: true

module Pike13
  module API
    module V2
      module Desk
        class Punch < Base
          class << self
            # GET /desk/punches
            def all
              client.get("desk/punches")
            end

            # GET /desk/punches/:id
            def find(id)
              client.get("desk/punches/#{id}")
            end

            # POST /desk/punches
            def create(attributes)
              client.post("desk/punches", { punch: attributes })
            end

            # DELETE /desk/punches/:id
            def destroy(id)
              client.delete("desk/punches/#{id}")
            end
          end
        end
      end
    end
  end
end
