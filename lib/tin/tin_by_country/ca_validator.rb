module Tin
  module TinByCountry
    class CaValidator < Base
      GST_REGEXP = /^\d{9}RT\d{4}$/
      GST_REGEXP_SHORT = /^\d{9}$/

      private

      def tin_type
        @tin_type ||= 'gst' if [9, 15].include?(tin.length)
      end

      def valid_tin?
        tin.match?(GST_REGEXP) || tin.match?(GST_REGEXP_SHORT)
      end

      def format_gst
        if tin.match?(GST_REGEXP_SHORT)
          "#{tin}RT0001"
        else
          tin
        end
      end
    end
  end
end
