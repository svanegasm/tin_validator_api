module Tin
  module TinByCountry
    class AuValidator < Base
      ABN_REGEXP = /(\d{2})(\d{3})(\d{3})(\d{3})/
      ACN_REGEXP = /(\d{3})(\d{3})(\d{3})/

      def validate
        base_response = super
        return base_response unless tin_type == 'abn'

        external_validation(base_response)
      end

      private

      def tin_type
        @tin_type ||= case tin.length
                      when 11
                        'abn'
                      when 9
                        'acn'
                      end
      end

      def valid_tin?
        case tin_type
        when 'abn'
          tin.match?(ABN_REGEXP) && algorithm_validation
        when 'acn'
          tin.match?(ACN_REGEXP)
        else
          false
        end
      end

      def format_abn
        tin.gsub(ABN_REGEXP, '\1 \2 \3 \4')
      end

      def format_acn
        tin.gsub(ACN_REGEXP, '\1 \2 \3')
      end

      def algorithm_validation
        weights = [10, 1, 3, 5, 7, 9, 11, 13, 15, 17, 19]
        sum = tin.chars.each_with_index.map do |char, index|
          digit = index.zero? ? char.to_i - 1 : char.to_i
          digit * weights[index]
        end.sum

        (sum % 89).zero?
      end

      def external_validation(base_response)
        abn_service = AbnValidationService.new(tin)
        external_response = abn_service.validate_with_external_service
        base_response[:errors] << external_response[:error] if external_response[:error].present?

        base_response.merge!(
          valid: external_response[:valid],
          business_registration: external_response[:business_registration],
          errors: base_response[:errors]
        )
      end
    end
  end
end
