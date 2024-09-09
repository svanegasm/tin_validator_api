module Tin
  module TinByCountry
    class Base
      attr_reader :tin, :country_code

      def initialize(country_code, tin)
        @tin = tin
        @country_code = country_code
      end

      def validate
        return { valid: false, errors: [I18n.t('tin.validates.invalid_length')] } unless tin_type

        {
          valid: valid_tin?,
          tin_type: "#{country_code}_#{tin_type}",
          formatted_tin: send("format_#{tin_type}"),
          errors: valid_tin? ? [] : [I18n.t('tin.validates.invalid_tin')]
        }
      end
    end
  end
end
