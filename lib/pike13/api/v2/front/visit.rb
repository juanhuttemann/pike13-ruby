# frozen_string_literal: true

module Pike13
  module API
    module V2
      module Front
        class Visit < Base
          class << self
            # GET /front/visits
            def all(**params)
              client.get("front/visits", params)
            end

            # GET /front/visits/:id
            def find(id)
              client.get("front/visits/#{id}")
            end

            # POST /front/visits
            def create(attributes)
              client.post("front/visits", { visit: attributes })
            end

            # DELETE /front/visits/:id
            def destroy(id, **params)
              client.delete("front/visits/#{id}", params)
            end
          end
        end
      end
    end
  end
end
