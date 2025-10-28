# frozen_string_literal: true

module Pike13
  # Validation helpers for Pike13 API parameters
  module Validators
    class ValidationError < StandardError; end

    # Validates idempotency token format (should be a non-empty string)
    #
    # @param token [String] The idempotency token
    # @raise [ValidationError] if token is invalid
    # @return [Boolean] true if valid
    def self.validate_idempotency_token!(token)
      if token.nil? || token.to_s.strip.empty?
        raise ValidationError, "Idempotency token cannot be blank"
      end

      unless token.is_a?(String)
        raise ValidationError, "Idempotency token must be a string, got #{token.class}"
      end

      if token.length > 255
        raise ValidationError, "Idempotency token must be 255 characters or less, got #{token.length}"
      end

      true
    end

    # Validates note attributes (must have 'note' key, not 'body')
    #
    # @param attributes [Hash] Note attributes
    # @raise [ValidationError] if attributes are invalid
    # @return [Boolean] true if valid
    def self.validate_note_attributes!(attributes)
      unless attributes.is_a?(Hash)
        raise ValidationError, "Note attributes must be a hash, got #{attributes.class}"
      end

      if attributes.key?(:body) || attributes.key?("body")
        raise ValidationError,
              "Note attributes should use 'note' key, not 'body'. " \
              "Example: { note: 'text', subject: 'optional' }"
      end

      if !attributes.key?(:note) && !attributes.key?("note")
        raise ValidationError, "Note attributes must include 'note' key"
      end

      note_value = attributes[:note] || attributes["note"]
      if note_value.to_s.strip.empty?
        raise ValidationError, "Note text cannot be blank"
      end

      true
    end

    # Validates form of payment type
    #
    # @param type [String] Form of payment type
    # @raise [ValidationError] if type is invalid
    # @return [Boolean] true if valid
    def self.validate_form_of_payment_type!(type)
      valid_types = %w[creditcard ach]

      unless type.is_a?(String)
        raise ValidationError, "Form of payment type must be a string, got #{type.class}"
      end

      unless valid_types.include?(type.downcase)
        raise ValidationError,
              "Form of payment type must be one of: #{valid_types.join(', ')}. Got: '#{type}'"
      end

      true
    end

    # Validates booking parameters
    #
    # @param params [Hash] Booking parameters
    # @raise [ValidationError] if parameters are invalid
    # @return [Boolean] true if valid
    def self.validate_booking_params!(params)
      unless params.is_a?(Hash)
        raise ValidationError, "Booking parameters must be a hash, got #{params.class}"
      end

      # Check for idempotency token
      token = params[:idempotency_token] || params["idempotency_token"]
      if token
        validate_idempotency_token!(token)
      end

      # Require either event_occurrence_id or leases array
      has_event = params[:event_occurrence_id] || params["event_occurrence_id"]
      has_leases = params[:leases] || params["leases"]

      unless has_event || has_leases
        raise ValidationError,
              "Booking must have either 'event_occurrence_id' or 'leases' parameter"
      end

      true
    end

    # Validates person attributes for creation
    #
    # @param attributes [Hash] Person attributes
    # @raise [ValidationError] if attributes are invalid
    # @return [Boolean] true if valid
    def self.validate_person_attributes!(attributes)
      unless attributes.is_a?(Hash)
        raise ValidationError, "Person attributes must be a hash, got #{attributes.class}"
      end

      # Check required fields
      first_name = attributes[:first_name] || attributes["first_name"]
      last_name = attributes[:last_name] || attributes["last_name"]

      if first_name.to_s.strip.empty?
        raise ValidationError, "Person must have a first_name"
      end

      if last_name.to_s.strip.empty?
        raise ValidationError, "Person must have a last_name"
      end

      # Validate email format if provided
      email = attributes[:email] || attributes["email"]
      if email && !email.to_s.match?(/\A[^@\s]+@[^@\s]+\z/)
        raise ValidationError, "Invalid email format: #{email}"
      end

      true
    end
  end
end
