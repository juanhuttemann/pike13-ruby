# frozen_string_literal: true

module Pike13
  module API
    module V2
      module Desk
        class Person < Spyke::Base
          uri "desk/people(/:id)"
          include_root_in_json :person

          # Associations - Spyke will replace :id with the person's id
          has_many :visits, class_name: "Pike13::API::V2::Desk::Visit", uri: "desk/people/:id/visits"
          has_many :plans, class_name: "Pike13::API::V2::Desk::Plan", uri: "desk/people/:id/plans"

          # Scopes
          scope :search, ->(query) { with("desk/people/search").where(q: query) }

          class << self
            def me
              find(:me)
            end
          end
        end
      end
    end
  end
end
