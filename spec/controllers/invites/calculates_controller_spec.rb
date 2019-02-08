require 'rails_helper'

RSpec.describe Invites::CalculatesController, type: :controller do
  describe '#update' do
    subject(:post_update) { put :update, xhr: true }

    before do
      allow(InvitesService::Calculate).to receive(:call) { return_service }
      post_update
    end

    describe 'JSON' do
      context 'when success' do
        let(:calc_result) { { 'A': 1.75, 'B': 1.5, 'C': 1 } }
        let(:return_service) { OpenStruct.new(calculated: calc_result, errors: nil ) }

        it { expect(response).to have_http_status :ok }
        it { expect(InvitesService::Calculate).to have_received(:call) }
      end

      context 'when not success' do
        let(:calc_result) { { } }
        let(:return_service) { OpenStruct.new(calculated: calc_result, errors: { extension_error: 'extension_error' } ) }

        it { expect(response).to have_http_status :unprocessable_entity }
        it { expect(InvitesService::Calculate).to have_received(:call) }
      end
    end
  end
end
