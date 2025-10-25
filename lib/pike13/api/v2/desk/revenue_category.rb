# frozen_string_literal: true

module Pike13
  module API
    module V2
      module Desk
        class RevenueCategory < Spyke::Base
          uri "desk/revenue_categories(/:id)"
          include_root_in_json :revenue_category
        end
      end
    end
  end
end
