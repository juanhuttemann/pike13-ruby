# frozen_string_literal: true

module Pike13
  module API
    module V2
      # Module for managing dynamic attributes from API responses
      # Automatically creates attr_readers for each attribute in the response
      module Attributes
        attr_reader :attributes

        # Initialize attributes from a hash
        # Creates instance variables and attr_readers for each key
        #
        # @param attributes [Hash] Hash of attribute key-value pairs
        def initialize_attributes(**attributes)
          @attributes = attributes
          attributes.each do |key, value|
            instance_variable_set("@#{key}", value)
            define_singleton_accessor(key)
          end
        end

        # Get the resource ID
        # Handles both @id instance variable and attributes hash
        #
        # @return [Integer, nil] The resource ID
        def id
          @id || attributes[:id]
        end

        # Reload the resource from the API
        # Refreshes all attributes with latest data
        #
        # @return [self] The reloaded resource
        def reload
          raise NotImplementedError, "#{self.class} must implement reload method"
        end

        private

        def define_singleton_accessor(key)
          singleton_class.attr_reader(key) unless respond_to?(key)
        end
      end
    end
  end
end
