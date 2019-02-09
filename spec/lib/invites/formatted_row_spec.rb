require 'rails_helper'
require './lib/invites/formatted_row'

RSpec.describe Invites::FormattedRow do
  let(:row) { '2018-06-12 09:41 A recommends B' }
  subject { described_class.new(row) }

  describe '.date_parse' do
    context 'when success' do
      let(:date_formated) { Time.zone.parse('2018-06-12 09:41') }
      it { expect(subject.date).to eq date_formated }
    end

    context 'when not success and return nil' do
      let(:row) { 'sasdsad A recommends B' }
      it { expect(subject.date).to be nil }
    end
  end

  describe '.fill_action' do
    context 'when return :recommends' do
      it { expect(subject.action).to be :recommends }
    end

    context 'when return :accepts' do
      let(:row) { 'sasdsad A accepts' }
      it { expect(subject.action).to be :accepts }
    end
  end

  describe '.fill_from' do
    context 'when return A' do
      it { expect(subject.from).to eq 'A' }
    end

    context 'when return C' do
      let(:row) { '2018-06-12 09:41 C recommends D' }
      it { expect(subject.from).to eq 'C' }
    end

    context 'when return nil' do
      let(:row) { '' }
      it { expect(subject.from).to eq nil }
    end
  end

  describe '.fill_to' do
    context 'when return B' do
      it { expect(subject.to).to eq 'B' }
    end

    context 'when return D' do
      let(:row) { '2018-06-12 09:41 C recommends D' }
      it { expect(subject.to).to eq 'D' }
    end

    context 'when return nil' do
      let(:row) { '' }
      it { expect(subject.to).to eq nil }
    end
  end
end
