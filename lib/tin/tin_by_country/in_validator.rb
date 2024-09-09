module Tin
  module TinByCountry
    class InValidator < Base
      GST_REGEXP = /^\d{2}[A-Za-z0-9]{10}\d[A-Za-z]\d$/

      private

      def tin_type
        @tin_type ||= 'gst' if tin.length == 15
      end

      def valid_tin?
        tin.match?(GST_REGEXP)
      end

      def format_gst
        tin
      end
    end
  end
end
