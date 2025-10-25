# frozen_string_literal: true

module Pike13
  module API
    module V2
      module Desk
        class Service < Spyke::Base
          uri "desk/services(/:id)"
          include_root_in_json :service

          class << self
            def enrollment_eligibilities(service_id:, **params)
              result = request(:get, "desk/services/#{service_id}/enrollment_eligibilities", params)
              # Pike13JSONParser extracts "enrollment_eligibilities" and puts it in data
              result.data || []
            end
          end
        end
      end
    end
  end
end
