require 'rails_helper'
require './lib/invites/formatted_row'

RSpec.describe InvitesService::ReadFile do
  let(:file_invites_line) do
    <<-AWARD
      2018-06-12 09:41 A recommends B
      2018-06-14 09:41 B accepts
      2018-06-16 09:41 B recommends C
      2018-06-17 09:41 C accepts
      2018-06-19 09:41 C recommends D
      2018-06-23 09:41 B recommends D
      2018-06-25 09:41 D accepts
    AWARD
  end
  let(:data_file_splited) { file_invites_line.split("\n") }
  let(:formatted_rows) do
    data_file_splited.map do |row|
      ::Invites::FormattedRow.new(row)
    end.sort
  end

  let(:file_hash) do
    {
      filename: 'invites_ok.txt',
      type: 'text/plain',
      tempfile: File.new(Rails.root.join('spec/fixtures/myfiles/invites_ok.txt'))
    }
  end

  let(:test_txt) do
    ActionDispatch::Http::UploadedFile.new(file_hash)
  end

  subject(:service) { described_class.new(test_txt) }

  describe '#initialize' do
    it { expect(service.file).to eq test_txt }
  end

  describe '.call' do
    let(:service_call) { service.call }

    it { expect(service_call).to be_a_kind_of Hash }
    it { expect(service_call[:errors]).to be nil }
    it { expect(service_call[:invites].count).to eq 7 }

    context 'invite index 0' do
      it { expect(service_call[:invites][0].action).to eq formatted_rows[0].action }
      it { expect(service_call[:invites][0].date).to eq formatted_rows[0].date }
      it { expect(service_call[:invites][0].from).to eq formatted_rows[0].from }
      it { expect(service_call[:invites][0].row).to eq formatted_rows[0].row }
      it { expect(service_call[:invites][0].to).to eq formatted_rows[0].to }
    end

    context 'invite index 1' do
      it { expect(service_call[:invites][1].action).to eq formatted_rows[1].action }
      it { expect(service_call[:invites][1].date).to eq formatted_rows[1].date }
      it { expect(service_call[:invites][1].from).to eq formatted_rows[1].from }
      it { expect(service_call[:invites][1].row).to eq formatted_rows[1].row }
      it { expect(service_call[:invites][1].to).to eq formatted_rows[1].to }
    end

    context 'invite index 2' do
      it { expect(service_call[:invites][2].action).to eq formatted_rows[2].action }
      it { expect(service_call[:invites][2].date).to eq formatted_rows[2].date }
      it { expect(service_call[:invites][2].from).to eq formatted_rows[2].from }
      it { expect(service_call[:invites][2].row).to eq formatted_rows[2].row }
      it { expect(service_call[:invites][2].to).to eq formatted_rows[2].to }
    end

    context 'invite index 3' do
      it { expect(service_call[:invites][3].action).to eq formatted_rows[3].action }
      it { expect(service_call[:invites][3].date).to eq formatted_rows[3].date }
      it { expect(service_call[:invites][3].from).to eq formatted_rows[3].from }
      it { expect(service_call[:invites][3].row).to eq formatted_rows[3].row }
      it { expect(service_call[:invites][3].to).to eq formatted_rows[3].to }
    end

    context 'invite index 4' do
      it { expect(service_call[:invites][4].action).to eq formatted_rows[4].action }
      it { expect(service_call[:invites][4].date).to eq formatted_rows[4].date }
      it { expect(service_call[:invites][4].from).to eq formatted_rows[4].from }
      it { expect(service_call[:invites][4].row).to eq formatted_rows[4].row }
      it { expect(service_call[:invites][4].to).to eq formatted_rows[4].to }
    end

    context 'invite index 5' do
      it { expect(service_call[:invites][5].action).to eq formatted_rows[5].action }
      it { expect(service_call[:invites][5].date).to eq formatted_rows[5].date }
      it { expect(service_call[:invites][5].from).to eq formatted_rows[5].from }
      it { expect(service_call[:invites][5].row).to eq formatted_rows[5].row }
      it { expect(service_call[:invites][5].to).to eq formatted_rows[5].to }
    end

  end
end
