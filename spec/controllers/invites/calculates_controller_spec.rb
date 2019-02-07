require 'rails_helper'

RSpec.describe Invites::CalculatesController, type: :controller do
  describe '#update' do

    let(:file) { Rack::Test::UploadedFile.new(Rails.root.join('spec/fixtures/myfiles/invites_ok.txt')) }

    let(:params) { { file: file } }

    subject(:post_update) { patch :update, params: params, xhr: true }

    before do
      allow(InvitesService::Calculate).to receive(:call).with(file) { return_service }
      post_update
    end

    describe 'JSON' do
      context 'when success' do
        let(:calc_result) { { 'A': 1.75, 'B': 1.5, 'C': 1 } } 
        let(:return_service) { OpenStruct.new(calc_result: calc_result, errors: {} ) } 

        it { expect(response).to have_http_status :ok }
        it { expect(InvitesService::Calculate).to have_received(:call).with(file) }
      end

      context 'when not success' do
        let(:calc_result) { { } }
        let(:return_service) { OpenStruct.new(calc_result: calc_result, errors: { extension_error: 'extension_error' } ) } 

        it { expect(response).to have_http_status :unprocessable_entity }
        it { expect(InvitesService::Calculate).to have_received(:call).with(file) }
      end
    end
  end
end
