# frozen_string_literal: true

module Errors
  module Handler
    extend ActiveSupport::Concern

    def handle_error(errors, status = :bad_request)
      return if context.failure?

      context.fail!(valid: false, errors:, status:)
    end
  end
end
