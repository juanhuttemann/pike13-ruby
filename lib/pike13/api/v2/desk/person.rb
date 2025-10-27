# frozen_string_literal: true

module Pike13
  module API
    module V2
      module Desk
        class Person < Base
          class << self
            # GET /desk/people
            def all
              client.get("desk/people")
            end

            # GET /desk/people/:id
            def find(id)
              client.get("desk/people/#{id}")
            end

            # GET /desk/people/me
            def me
              find(:me)
            end

            # GET /desk/people/search?q=query
            def search(query)
              client.get("desk/people/search", q: query)
            end

            # POST /desk/people
            def create(attributes)
              client.post("desk/people", { person: attributes })
            end

            # PUT /desk/people/:id
            def update(id, attributes)
              client.put("desk/people/#{id}", { person: attributes })
            end

            # DELETE /desk/people/:id
            def destroy(id)
              client.delete("desk/people/#{id}")
            end
          end
        end
      end
    end
  end
end
