# frozen_string_literal: true

module Pike13
  module API
    module V2
      module Front
        class FormOfPayment < Base
          class << self
            # GET /front/people/:person_id/form_of_payments
            def all(person_id:, **params)
              client.get("front/people/#{person_id}/form_of_payments", params)
            end

            # GET /front/people/:person_id/form_of_payments/:id
            def find(person_id:, id:)
              client.get("front/people/#{person_id}/form_of_payments/#{id}")
            end

            # GET /front/people/me/form_of_payments/:id
            def find_me(id:)
              client.get("front/people/me/form_of_payments/#{id}")
            end

            # POST /front/people/:person_id/form_of_payments
            def create(person_id:, attributes:)
              client.post("front/people/#{person_id}/form_of_payments", { form_of_payment: attributes })
            end

            # PUT /front/people/:person_id/form_of_payments/:id
            def update(person_id:, id:, attributes:)
              client.put("front/people/#{person_id}/form_of_payments/#{id}", { form_of_payment: attributes })
            end

            # DELETE /front/people/:person_id/form_of_payments/:id
            def destroy(person_id:, id:)
              client.delete("front/people/#{person_id}/form_of_payments/#{id}")
            end
          end
        end
      end
    end
  end
end
