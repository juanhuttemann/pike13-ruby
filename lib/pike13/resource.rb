# frozen_string_literal: true

module Pike13
  class Resource
    attr_reader :client

    def initialize(client)
      @client = client
    end

    private

    def get(path, params: {}, scoped: false)
      client.http_client.get(path, params: params, scoped: scoped)
    end
  end
end
