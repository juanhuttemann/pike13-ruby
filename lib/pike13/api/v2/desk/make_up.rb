# frozen_string_literal: true

module Pike13
  module API
    module V2
      module Desk
        class MakeUp < Base
          class << self
            # GET /desk/make_ups/reasons
            def reasons
              client.get("desk/make_ups/reasons")
            end

            # POST /desk/make_ups/generate
            def generate(visit_id:, make_up_reason_id:, free_form_reason: nil)
              body = {
                visit_id: visit_id,
                make_up: {
                  make_up_reason_id: make_up_reason_id
                }
              }
              body[:make_up][:free_form_reason] = free_form_reason if free_form_reason

              client.post("desk/make_ups/generate", body)
            end
          end
        end
      end
    end
  end
end
