# frozen_string_literal: true

module Pike13
  module API
    module V2
      module Desk
        class Refund < Base
          class << self
            # GET /desk/refunds/:id
            def find(id)
              client.get("desk/refunds/#{id}")
            end

            # POST /desk/refunds/:refund_id/voids
            def void(refund_id:)
              client.post("desk/refunds/#{refund_id}/voids", {})
            end
          end
        end
      end
    end
  end
end
