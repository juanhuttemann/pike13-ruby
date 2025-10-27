# frozen_string_literal: true

module Pike13
  module API
    module V2
      module Desk
        class FormOfPayment < Base
          class << self
            # GET /desk/people/:person_id/form_of_payments
            def all(person_id:, **params)
              client.get("desk/people/#{person_id}/form_of_payments", params)
            end

            # GET /desk/people/:person_id/form_of_payments/:id
            def find(person_id:, id:)
              client.get("desk/people/#{person_id}/form_of_payments/#{id}")
            end

            # POST /desk/people/:person_id/form_of_payments
            def create(person_id:, attributes:)
              client.post("desk/people/#{person_id}/form_of_payments", { form_of_payment: attributes })
            end

            # PUT /desk/people/:person_id/form_of_payments/:id
            def update(person_id:, id:, attributes:)
              client.put("desk/people/#{person_id}/form_of_payments/#{id}", { form_of_payment: attributes })
            end

            # DELETE /desk/people/:person_id/form_of_payments/:id
            def destroy(person_id:, id:)
              client.delete("desk/people/#{person_id}/form_of_payments/#{id}")
            end
          end
        end
      end
    end
  end
end
