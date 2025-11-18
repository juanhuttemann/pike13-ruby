# frozen_string_literal: true

module Pike13
  module API
    module V2
      module Desk
        class Visit < Base
          class << self
            # GET /desk/visits/:id
            def find(id)
              client.get("desk/visits/#{id}")
            end

            # GET /desk/people/:person_id/visits/summary
            def summary(person_id:, **params)
              client.get("desk/people/#{person_id}/visits/summary", params)
            end

            # POST /desk/visits
            def create(attributes)
              client.post("desk/visits", { visit: attributes })
            end

            # PUT /desk/visits/:id
            def update(id, attributes)
              client.put("desk/visits/#{id}", { visit: attributes })
            end

            # DELETE /desk/visits/:id
            def destroy(id, **params)
              client.delete("desk/visits/#{id}", params)
            end
          end
        end
      end
    end
  end
end
