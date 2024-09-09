# frozen_string_literal: true

class ApplicationController < ActionController::API
  protected

  def formatted_response(context)
    render json: ResponseBuilder.build(context), status: context[:status]
  end
end
