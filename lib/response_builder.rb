class ResponseBuilder
  class << self
    def build(context)
      context.to_h.slice(*permitted_params)
    end

    private

    def permitted_params
      %i[valid tin_type formatted_tin errors business_registration]
    end
  end
end
