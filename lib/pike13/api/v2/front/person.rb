# frozen_string_literal: true

module Pike13
  module API
    module V2
      module Front
        class Person < Base
          class << self
            # GET /front/people/:id
            def find(id)
              client.get("front/people/#{id}")
            end

            # GET /front/people/me
            def me
              find(:me)
            end
          end
        end
      end
    end
  end
end
