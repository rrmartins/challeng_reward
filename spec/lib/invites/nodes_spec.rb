require 'rails_helper'
require './lib/invites/node'

RSpec.describe Invites::Node do
  describe 'parent' do
    let(:node) { described_class.new('A') }

    it { expect(node.value).to eq 'A' }
    it { expect(node.points).to eq 0 }
    it { expect(node.accepts?).to be_falsy }
  end

  describe 'child' do
    let(:options) { { from: 'A', date: DateTime.current, accepts: true } } 
    let(:node) { described_class.new('B', 'A', options) }

    it { expect(node.value).to eq 'B' }
    it { expect(node.points).to eq 0 }
    it { expect(node.parent).to eq 'A' }
    it { expect(node.options).to eq options }
    it { expect(node.accepts?).to be_truthy }
  end
end
