class AbnValidationService
  attr_reader :tin

  def initialize(tin)
    @tin = tin
  end

  def validate_with_external_service
    response = HTTParty.get("http://localhost:8080/queryABN?abn=#{tin}")
    return error_response(response.code) if response.code > 299

    data = Hash.from_xml(response.body)
    business_entity = data['abn_response']['response']['businessEntity']

    {
      valid: tin_valid?(business_entity),
      business_registration: {
        name: business_entity['organisationName'],
        address: "#{business_entity['address']['stateCode']}, #{business_entity['address']['postcode']}"
      },
      error: tin_valid?(business_entity) ? nil : 'business is not GST registered'
    }
  end

  private

  def tin_valid?(business_entity)
    business_entity['goodsAndServicesTax'] == 'true'
  end

  def error_response(code)
    case code
    when 404
      { valid: false, error: 'business is not registered' }
    when 500
      { valid: false, error: 'registration API could not be reached' }
    else
      { valid: false, error: 'unknow error' }
    end
  end
end
