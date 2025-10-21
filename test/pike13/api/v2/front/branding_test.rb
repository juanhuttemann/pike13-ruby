# frozen_string_literal: true

require "test_helper"

module Pike13
  module API
    module V2
      module Front
        class BrandingTest < Minitest::Test
          def setup
            @client = default_client
          end

          def test_find_branding
            stub_pike13_request(:get, "/front/branding", scope: "front", response_body: {
                                  "branding" => { "id" => 1 }
                                })

            item = @client.front.branding.find

            assert_equal 1, item.id
          end
        end
      end
    end
  end
end
