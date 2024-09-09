# frozen_string_literal: true

module Tin
  module Validates
    class Index
      include Interactor
      include Errors::Handler

      delegate :tin, :country_code, to: :context

      before do
        context.errors = []
        context.resolver = Tin::Resolver.new(country_code).resolve
        validate!
      end

      def call
        validation_response = validate_tin
        context.valid = validation_response[:valid]
        context.tin_type = validation_response[:tin_type]
        context.formatted_tin = validation_response[:formatted_tin]
        context.errors += validation_response[:errors]
        context.business_registration = validation_response[:business_registration] if validation_response[:business_registration].present?
      end

      private

      def validate!
        fill_errors

        handle_error(context.errors) if context.errors.present?
      end

      def validate_tin
        context.resolver.new(
          country_code.downcase,
          tin.gsub(/\s+/, '')
        ).validate
      end

      def fill_errors
        context.errors << format(I18n.t('tin.validates.not_implemented'), country_code) if context.resolver.blank? && country_code.present?
        context.errors << format(I18n.t('tin.validates.field_empty'), 'Country Code') if country_code.blank?
        context.errors << format(I18n.t('tin.validates.field_empty'), 'TIN') if tin.blank?
      end
    end
  end
end
