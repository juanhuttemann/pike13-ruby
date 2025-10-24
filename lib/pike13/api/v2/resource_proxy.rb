# frozen_string_literal: true

module Pike13
  module API
    module V2
      class ResourceProxy
        def initialize(resource_class, client)
          @resource_class = resource_class
          @client = client
        end

        def find(id = nil, **params)
          if id
            @resource_class.find(id: id, client: @client, **params)
          else
            @resource_class.find(client: @client, **params)
          end
        end

        def all(**params)
          @resource_class.all(client: @client, **params)
        end

        def method_missing(method, *args, **kwargs, &block)
          if @resource_class.respond_to?(method)
            @resource_class.public_send(method, *args, client: @client, **kwargs, &block)
          else
            super
          end
        end

        def respond_to_missing?(method, include_private = false)
          @resource_class.respond_to?(method) || super
        end
      end
    end
  end
end
