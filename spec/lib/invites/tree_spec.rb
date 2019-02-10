require 'rails_helper'
require './lib/invites/tree'

RSpec.describe Invites::Tree do
  let(:tree) { described_class.new('Award') }

  describe '#initialize' do
    it { expect(tree).not_to be_nil }
    it { expect(tree.mapping).to be_empty }
  end

  describe '.insert' do
    let(:sub_node) { tree.add_award_node('A', 'B') }
    it { expect(sub_node.parent.value).to eq 'A' }
  end

  describe '.add_points_to_parents' do
    before { tree.add_award_node('A', 'B', accepts: true) }

    context 'when point A is 1' do
      it { expect(tree.points['A']).to eq 1 }
    end

    context 'when point A is 1.5' do
      before { tree.add_award_node('B', 'C', accepts: true) }
      it { expect(tree.points['A']).to eq 1.5 }
    end

    context 'when point A is 1.75' do
      before do 
        tree.add_award_node('B', 'C', accepts: true)
        tree.add_award_node('C', 'D', accepts: true)
      end
      it { expect(tree.points['A']).to eq 1.75 }
    end
  end
end
