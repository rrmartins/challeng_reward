require './lib/invites/tree'

module InvitesService
  class Calculator
    attr_reader :items

    def initialize(items)
      @items = items
    end

    def self.call(file)
      new(file).call
    end

    def call
      calculator
    end

    private

    def calculator
      build_tree
      tree.points.reject { |_k, v| v.zero? }
    end

    def build_tree
      items.each do |item|
        if item.accepts?
          tree.update_award_options(item.from, accepts: true)
        else
          tree.add_award_node(item.from, item.to, from: item.from, date: item.date)
        end
      end
    end

    def tree
      @tree ||= ::Invites::Tree.new('Award')
    end
  end
end
