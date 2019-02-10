module Invites
  class Node
    attr_reader :value
    attr_accessor :options, :points, :parent

    def initialize(value = nil, parent = nil, options = {})
      @value = value
      @points = 0
      @parent = parent
      @options = options
    end

    def accepts?
      options[:accepts]
    end
  end
end
