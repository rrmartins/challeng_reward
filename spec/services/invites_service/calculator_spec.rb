require 'rails_helper'
require './lib/invites/formatted_row'

RSpec.describe InvitesService::Calculator do
  let(:data_file_splited) { file_invites_line.split("\n") }
  let(:formatted_rows) do
    data_file_splited.map do |row|
      ::Invites::FormattedRow.new(row)
    end.sort
  end

  subject(:service_call) { described_class.call(formatted_rows) }

  describe '.calculator' do
    context 'simple awards' do
      let(:file_invites_line) do
        <<-AWARD
          2018-06-12 09:41 A recommends B
          2018-06-14 09:41 B accepts
          2018-06-16 09:41 B recommends C
        AWARD
      end

      it { expect(service_call).to eq('A' => 1) }
    end

    context 'complex awards' do
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
      it { expect(service_call).to eq('A' => 1.75, 'B' => 1.5, 'C' => 1) }
    end
  end
end
