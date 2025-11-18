# frozen_string_literal: true

module Pike13
  module API
    module V2
      module Desk
        class Person < Base
          class << self
            # GET /desk/people
            def all(**params)
              client.get("desk/people", params)
            end

            # GET /desk/people/:id
            def find(id)
              client.get("desk/people/#{id}")
            end

            # GET /desk/people/me
            def me
              find(:me)
            end

            # GET /desk/people/search?q=query&fields=fields
            def search(query, fields: nil)
              params = { q: query }
              params[:fields] = fields if fields
              client.get("desk/people/search", params)
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
