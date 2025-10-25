# frozen_string_literal: true

module Pike13
  module API
    module V2
      module Front
        class Person < Spyke::Base
          uri "front/people(/:id)"
          include_root_in_json :person

          has_many :visits, class_name: "Pike13::API::V2::Front::Visit", uri: "front/people/:person_id/visits"
          has_many :waitlist_entries, class_name: "Pike13::API::V2::Front::WaitlistEntry",
                                      uri: "front/people/:person_id/waitlist_entries"

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
