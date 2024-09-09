module Tin
  module TinByCountry
    class Base
      attr_reader :tin, :country_code

      def initialize(country_code, tin)
        @tin = tin
        @country_code = country_code
      end

      def validate
        return invalid_response(I18n.t('tin.validates.invalid_length')) unless tin_type
        return invalid_response(I18n.t('tin.validates.invalid_tin')) unless valid_tin?

        {
          valid: true,
          tin_type: "#{country_code}_#{tin_type}",
          formatted_tin: send("format_#{tin_type}"),
          errors: []
        }
      end

      private

      def invalid_response(error_message)
        {
          valid: false,
          errors: [error_message]
        }
      end
    end
  end
end
