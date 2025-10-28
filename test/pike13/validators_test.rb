# frozen_string_literal: true

require "test_helper"

module Pike13
  class ValidatorsTest < Minitest::Test
    # Idempotency Token Validation Tests
    def test_validate_idempotency_token_success
      assert Pike13::Validators.validate_idempotency_token!("valid-token-123")
      assert Pike13::Validators.validate_idempotency_token!(SecureRandom.uuid)
    end

    def test_validate_idempotency_token_nil
      error = assert_raises(Pike13::Validators::ValidationError) do
        Pike13::Validators.validate_idempotency_token!(nil)
      end
      assert_match(/cannot be blank/, error.message)
    end

    def test_validate_idempotency_token_empty
      error = assert_raises(Pike13::Validators::ValidationError) do
        Pike13::Validators.validate_idempotency_token!("   ")
      end
      assert_match(/cannot be blank/, error.message)
    end

    def test_validate_idempotency_token_not_string
      error = assert_raises(Pike13::Validators::ValidationError) do
        Pike13::Validators.validate_idempotency_token!(12_345)
      end
      assert_match(/must be a string/, error.message)
    end

    def test_validate_idempotency_token_too_long
      error = assert_raises(Pike13::Validators::ValidationError) do
        Pike13::Validators.validate_idempotency_token!("a" * 256)
      end
      assert_match(/255 characters or less/, error.message)
    end

    # Note Attributes Validation Tests
    def test_validate_note_attributes_success
      assert Pike13::Validators.validate_note_attributes!(note: "Valid note")
      assert Pike13::Validators.validate_note_attributes!(note: "Note", subject: "Subject")
      assert Pike13::Validators.validate_note_attributes!("note" => "Valid note")
    end

    def test_validate_note_attributes_with_body_key
      error = assert_raises(Pike13::Validators::ValidationError) do
        Pike13::Validators.validate_note_attributes!(body: "Should use note key")
      end
      assert_match(/should use 'note' key, not 'body'/, error.message)
    end

    def test_validate_note_attributes_missing_note
      error = assert_raises(Pike13::Validators::ValidationError) do
        Pike13::Validators.validate_note_attributes!(subject: "Has subject but no note")
      end
      assert_match(/must include 'note' key/, error.message)
    end

    def test_validate_note_attributes_blank_note
      error = assert_raises(Pike13::Validators::ValidationError) do
        Pike13::Validators.validate_note_attributes!(note: "   ")
      end
      assert_match(/cannot be blank/, error.message)
    end

    def test_validate_note_attributes_not_hash
      error = assert_raises(Pike13::Validators::ValidationError) do
        Pike13::Validators.validate_note_attributes!("not a hash")
      end
      assert_match(/must be a hash/, error.message)
    end

    # Form of Payment Type Validation Tests
    def test_validate_form_of_payment_type_success
      assert Pike13::Validators.validate_form_of_payment_type!("creditcard")
      assert Pike13::Validators.validate_form_of_payment_type!("ach")
      assert Pike13::Validators.validate_form_of_payment_type!("CreditCard") # case insensitive
    end

    def test_validate_form_of_payment_type_invalid
      error = assert_raises(Pike13::Validators::ValidationError) do
        Pike13::Validators.validate_form_of_payment_type!("paypal")
      end
      assert_match(/must be one of: creditcard, ach/, error.message)
    end

    def test_validate_form_of_payment_type_not_string
      error = assert_raises(Pike13::Validators::ValidationError) do
        Pike13::Validators.validate_form_of_payment_type!(123)
      end
      assert_match(/must be a string/, error.message)
    end

    # Booking Parameters Validation Tests
    def test_validate_booking_params_success
      assert Pike13::Validators.validate_booking_params!(
        event_occurrence_id: 123,
        person_id: 456,
        idempotency_token: SecureRandom.uuid
      )
    end

    def test_validate_booking_params_with_leases
      assert Pike13::Validators.validate_booking_params!(
        leases: [{ event_occurrence_id: 123 }],
        idempotency_token: "token-123"
      )
    end

    def test_validate_booking_params_missing_required
      error = assert_raises(Pike13::Validators::ValidationError) do
        Pike13::Validators.validate_booking_params!(
          person_id: 456,
          idempotency_token: "token"
        )
      end
      assert_match(/must have either 'event_occurrence_id' or 'leases'/, error.message)
    end

    def test_validate_booking_params_invalid_token
      error = assert_raises(Pike13::Validators::ValidationError) do
        Pike13::Validators.validate_booking_params!(
          event_occurrence_id: 123,
          idempotency_token: ""
        )
      end
      assert_match(/cannot be blank/, error.message)
    end

    def test_validate_booking_params_not_hash
      error = assert_raises(Pike13::Validators::ValidationError) do
        Pike13::Validators.validate_booking_params!("not a hash")
      end
      assert_match(/must be a hash/, error.message)
    end

    # Person Attributes Validation Tests
    def test_validate_person_attributes_success
      assert Pike13::Validators.validate_person_attributes!(
        first_name: "John",
        last_name: "Doe",
        email: "john@example.com"
      )
    end

    def test_validate_person_attributes_minimum
      assert Pike13::Validators.validate_person_attributes!(
        first_name: "John",
        last_name: "Doe"
      )
    end

    def test_validate_person_attributes_missing_first_name
      error = assert_raises(Pike13::Validators::ValidationError) do
        Pike13::Validators.validate_person_attributes!(
          last_name: "Doe",
          email: "john@example.com"
        )
      end
      assert_match(/must have a first_name/, error.message)
    end

    def test_validate_person_attributes_missing_last_name
      error = assert_raises(Pike13::Validators::ValidationError) do
        Pike13::Validators.validate_person_attributes!(
          first_name: "John",
          email: "john@example.com"
        )
      end
      assert_match(/must have a last_name/, error.message)
    end

    def test_validate_person_attributes_invalid_email
      error = assert_raises(Pike13::Validators::ValidationError) do
        Pike13::Validators.validate_person_attributes!(
          first_name: "John",
          last_name: "Doe",
          email: "invalid-email"
        )
      end
      assert_match(/Invalid email format/, error.message)
    end

    def test_validate_person_attributes_not_hash
      error = assert_raises(Pike13::Validators::ValidationError) do
        Pike13::Validators.validate_person_attributes!("not a hash")
      end
      assert_match(/must be a hash/, error.message)
    end
  end
end
