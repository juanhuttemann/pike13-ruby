# frozen_string_literal: true

module Pike13
  module API
    module V2
      # Module for JSON serialization of API resources
      # Provides methods to convert resources to JSON and Hash formats
      module Serialization
        # Convert resource to JSON string
        #
        # @param args [Array] Arguments passed to JSON generator
        # @return [String] JSON representation of the resource
        def to_json(*args)
          as_json.to_json(*args)
        end

        # Convert resource to Hash with string keys
        # Suitable for JSON serialization
        #
        # @param _options [Hash] Options (not currently used, for compatibility)
        # @return [Hash] Hash representation with string keys
        def as_json(_options = nil)
          attributes.transform_keys(&:to_s)
        end

        # Human-readable string representation of the resource
        # Shows class name, object ID, and all attributes
        #
        # @return [String] Inspection string
        def inspect
          "#<#{self.class.name}:0x#{object_id.to_s(16)} #{formatted_attributes}>"
        end

        alias to_s inspect

        private

        def formatted_attributes
          attributes.map { |k, v| "@#{k}=#{v.inspect}" }.join(", ")
        end
      end
    end
  end
end
