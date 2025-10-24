# frozen_string_literal: true

require "test_helper"

module Pike13
  module API
    module V2
      module Desk
        class PackTest < Minitest::Test
          def setup
            @client = default_client
          end

          def test_find_pack
            stub_pike13_request(:get, "/desk/packs/123", response_body: {
                                  "packs" => [{ "id" => 123 }]
                                })

            pack = @client.desk.packs.find(123)

            assert_equal 123, pack.id
          end
        end
      end
    end
  end
end
