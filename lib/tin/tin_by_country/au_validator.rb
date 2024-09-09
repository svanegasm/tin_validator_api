module Tin
  module TinByCountry
    class AuValidator < Base
      ABN_REGEXP = /(\d{2})(\d{3})(\d{3})(\d{3})/
      ACN_REGEXP = /(\d{3})(\d{3})(\d{3})/

      private

      def tin_type
        @tin_type ||= begin
          return 'abn' if tin.length == 11

          'acn' if tin.length == 9
        end
      end

      def valid_tin?
        case tin_type
        when 'abn'
          tin.match?(ABN_REGEXP)
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
    end
  end
end
