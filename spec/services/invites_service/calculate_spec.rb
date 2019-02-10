require 'rails_helper'

RSpec.describe InvitesService::Calculate, type: :service do
  let(:invites_file) { 'spec/fixtures/myfiles/invites_ok.txt' }
  let(:filename) { 'invites_ok.txt' }

  let(:file_hash) do
    {
      filename: filename,
      type: 'text/plain',
      tempfile: File.new(Rails.root.join(invites_file))
    }
  end

  let(:test_txt) do
    ActionDispatch::Http::UploadedFile.new(file_hash)
  end

  subject(:service) { described_class.new(test_txt) }

  before { allow(InvitesService::ReadFile).to receive(:call) { return_read_file } }

  describe '#initializer' do
    it { expect(service.file).to eq test_txt }
  end

  describe '.call' do
    let(:service_call) { service.call }

    context 'when return success' do
      let(:invites) { { 'A' => 1.75, 'B' => 1.5, 'C' => 1 } }
      let!(:return_read_file) { { errors: nil, invites: invites } }
      let!(:return_service) do
        return_read_file.merge!(calculated: invites).delete(:invites)
        return_read_file
      end
      before do
        allow(InvitesService::Calculator).to receive(:call) { invites }
        service_call
      end

      it { expect(service_call).to eq return_service }
      it { expect(InvitesService::Calculator).to have_received(:call) }
      it { expect(InvitesService::ReadFile).to have_received(:call) }
    end

    context 'when return error' do
      let!(:return_read_file) { { errors: 'error', invites: nil } }
      before { service_call }

      it { expect(service_call[:errors]).to eq 'error' }
    end
  end
end
