# frozen_string_literal: true

module Api
  module V1
    module Tin
      class ValidatesController < ApplicationController
        def index
          result = ::Tin::Validates::Index.call(
            tin: index_params[:tin],
            country_code: index_params[:country_code]
          )
          formatted_response(result)
        end

        private

        def index_params
          params.permit(
            :tin,
            :country_code
          )
        end
      end
    end
  end
end
