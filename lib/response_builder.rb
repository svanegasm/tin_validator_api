class ResponseBuilder
  BASE_RESPONSE = {
    properties: {}
  }.freeze

  def self.build(context)
    BASE_RESPONSE[:properties].merge(
      valid: context[:valid],
      tin_type: context[:tin_type],
      formatted_tin: context[:formatted_tin],
      errors: context[:errors]
    )
  end
end