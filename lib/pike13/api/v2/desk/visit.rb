# frozen_string_literal: true

module Pike13
  module API
    module V2
      module Desk
        class Visit < Spyke::Base
          uri "desk/visits(/:id)"
          include_root_in_json :visit

          class << self
            def summary(person_id:, **params)
              url = "/api/v2/desk/people/#{person_id}/visits/summary"
              url += "?#{URI.encode_www_form(params)}" if params.any?
              response = connection.get(url)
              # API returns {"visit_summary": {...}}, Pike13JSONParser wraps singleton in array for non-single-resource GET
              data = response.body[:data]
              result = data.is_a?(Array) ? data.first || {} : data || {}
              result.deep_stringify_keys
            end
          end
        end
      end
    end
  end
end
