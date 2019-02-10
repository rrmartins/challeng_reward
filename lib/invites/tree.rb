require './lib/invites/node'

module Invites
  class Tree
    attr_accessor :root_node, :mapping

    MIN_VALUE = 1 / 4
    POINTS_COEFFICIENT = 2.0

    def initialize(root_value = nil)
      @root_node = Node.new(root_value)
      @mapping = {}
    end

    def add_award_node(parent, child, options = {})
      parent_node = mapping[parent]
      parent_node ||= insert(root_node, parent)
      child_node = mapping[child]
      insert(parent_node, child, options.merge(from: parent)) unless child_node
    end

    def update_award_options(key, options)
      node = search(key)
      node.options.merge!(options)
      add_points_to_parents(node, 1) if node.accepts?
      node
    end

    def search(node)
      mapping[node]
    end

    def points
      mapping.transform_values(&:points)
    end

    private

    def insert(node, value, options = {})
      return node if node.value == value

      new_node = Node.new(value, node, options)
      mapping[value] = new_node
      add_points_to_parents(new_node, 1) if new_node.accepts?
      new_node
    end

    def add_points_to_parents(node, points)
      return if points < MIN_VALUE
      return unless node.accepts?

      parent_node = node.parent
      parent_node.points += points
      add_points_to_parents(parent_node, points / POINTS_COEFFICIENT)
    end
  end
end
