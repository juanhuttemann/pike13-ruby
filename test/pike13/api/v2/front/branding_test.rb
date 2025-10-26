# frozen_string_literal: true

require "test_helper"

module Pike13
  module API
    module V2
      module Front
        class BrandingTest < Minitest::Test
          def setup
            setup_pike13
          end

          def test_find_branding
            stub_pike13_request(:get, "https://test.pike13.com/api/v2/front/branding", response_body: {
                                  "branding" => { "id" => 1 }
                                })

            item = Pike13::API::V2::Front::Branding.all.first

            assert_equal 1, item.id
          end
        end
      end
    end
  end
end
