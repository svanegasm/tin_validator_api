# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::Tin::ValidatesController, type: :controller do
  describe 'GET #index' do
    context 'valid ABN TIN' do
      let(:country_code) { 'AU' }
      let(:tin) { '10120000004' }

      specify do
        get(:index, params: { tin:, country_code: })

        expect(response).to have_http_status(:ok)
        expect(json_response['valid']).to eq(true)
        expect(json_response['tin_type']).to eq('au_abn')
        expect(json_response['formatted_tin']).to eq('10 120 000 004')
        expect(json_response['errors']).to be_empty
      end
    end

    context 'valid ACN TIN' do
      let(:country_code) { 'AU' }
      let(:tin) { '123456789' }

      specify do
        get(:index, params: { tin:, country_code: })

        expect(response).to have_http_status(:ok)
        expect(json_response['valid']).to eq(true)
        expect(json_response['tin_type']).to eq('au_acn')
        expect(json_response['formatted_tin']).to eq('123 456 789')
        expect(json_response['errors']).to be_empty
      end
    end

    context 'valid GST CA TIN' do
      let(:country_code) { 'CA' }

      it 'should be success with full tin' do
        tin = '123456789RT0001'
        get(:index, params: { tin:, country_code: })

        expect(response).to have_http_status(:ok)
        expect(json_response['valid']).to eq(true)
        expect(json_response['tin_type']).to eq('ca_gst')
        expect(json_response['formatted_tin']).to eq(tin)
        expect(json_response['errors']).to be_empty
      end

      it 'should be success with short tin' do
        tin = '123456789'
        get(:index, params: { tin:, country_code: })

        expect(response).to have_http_status(:ok)
        expect(json_response['valid']).to eq(true)
        expect(json_response['tin_type']).to eq('ca_gst')
        expect(json_response['formatted_tin']).to eq("#{tin}RT0001")
        expect(json_response['errors']).to be_empty
      end
    end

    context 'valid GST IN TIN' do
      let(:country_code) { 'IN' }
      let(:tin) { '22BCDEF1G2FH1Z5' }

      specify do
        get(:index, params: { tin:, country_code: })

        expect(response).to have_http_status(:ok)
        expect(json_response['valid']).to eq(true)
        expect(json_response['tin_type']).to eq('in_gst')
        expect(json_response['formatted_tin']).to eq(tin)
        expect(json_response['errors']).to be_empty
      end
    end

    context 'invalid TIN' do
      let(:country_code) { 'AU' }
      let(:tin) { '12345' }

      specify do
        get(:index, params: { tin:, country_code: })

        expect(json_response['valid']).to eq(false)
        expect(json_response['tin_type']).to be_nil
        expect(json_response['formatted_tin']).to be_nil
        expect(json_response['errors']).to eq([I18n.t('tin.validates.invalid_length')])
      end
    end

    context 'Not implemented Country Code' do
      let(:country_code) { 'CO' }
      let(:tin) { '123456789' }

      specify do
        get(:index, params: { tin:, country_code: })

        expect(json_response['valid']).to eq(false)
        expect(json_response['tin_type']).to be_nil
        expect(json_response['formatted_tin']).to be_nil
        expect(json_response['errors']).to eq([format(I18n.t('tin.validates.not_implemented'), country_code)])
      end
    end

    context 'Empty params and not implemented country' do
      let(:country_code) { 'CO' }
      let(:tin) { '123456789' }

      it 'errors cause empty tin' do
        get(:index, params: { country_code: })

        expect(json_response['valid']).to eq(false)
        expect(json_response['tin_type']).to be_nil
        expect(json_response['formatted_tin']).to be_nil
        expect(json_response['errors']).to include(format(I18n.t('tin.validates.field_empty'), 'TIN'))
        expect(json_response['errors']).to include(format(I18n.t('tin.validates.not_implemented'), country_code))
      end

      it 'errors cause empty country_code' do
        get(:index, params: { tin: })

        expect(json_response['valid']).to eq(false)
        expect(json_response['tin_type']).to be_nil
        expect(json_response['formatted_tin']).to be_nil
        expect(json_response['errors']).to include(format(I18n.t('tin.validates.field_empty'), 'Country Code'))
      end

      it 'errors cause empty country_code and tin' do
        get(:index)

        expect(json_response['valid']).to eq(false)
        expect(json_response['tin_type']).to be_nil
        expect(json_response['formatted_tin']).to be_nil
        expect(json_response['errors']).to include(format(I18n.t('tin.validates.field_empty'), 'Country Code'))
        expect(json_response['errors']).to include(format(I18n.t('tin.validates.field_empty'), 'TIN'))
      end
    end
  end
end
