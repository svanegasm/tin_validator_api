module Tin
  class Resolver
    TIN_TYPES = {
      AU: Tin::TinByCountry::AuValidator,
      CA: Tin::TinByCountry::CaValidator,
      IN: Tin::TinByCountry::InValidator
    }.freeze

    def initialize(country_code)
      return unless country_code

      @country_code = country_code.upcase.to_sym
    end

    def resolve
      tin_validator unless tin_validator.nil?
    end

    private

    def tin_validator
      @tin_validator ||= TIN_TYPES[@country_code]
    end
  end
end
