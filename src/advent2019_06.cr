module Advent2019_06
  extend self

  private class TreeNode
    property value : String
    property parent : TreeNode | Nil
    property children : Array(TreeNode)

    def initialize(@value)
      @parent = nil
      @children = [] of TreeNode
    end

    def add(child)
      child.parent = self
      @children << child
    end

    def depth
      parent = @parent
      if parent.nil?
        0
      else
        1 + parent.depth
      end
    end

    def each_preorder(&block : TreeNode ->)
      yield self
      @children.each do |child|
        child.each_preorder &block
      end
    end

    def ancestors
      parent = @parent
      if parent.nil?
        [] of TreeNode
      else
        [parent].concat parent.ancestors
      end
    end
  end

  private def parse(input)
    nodes = {} of String => TreeNode

    input.lines.each do |line|
      orbit = line.split(')')
      orbit.each do |obj|
        if !nodes.has_key? obj
          nodes[obj] = TreeNode.new obj
        end
      end

      nodes[orbit[0]].add nodes[orbit[1]]
    end

    nodes
  end

  def name
    "2019 Day 6: Universal Orbit Map"
  end

  def part1(input)
    nodes = parse input
    total = 0

    nodes["COM"].each_preorder do |node|
      total += node.depth
    end

    total
  end

  def part2(input)
    # Find the common ancestor between SAN and YOU and count the hops.
    nodes = parse input
    santa_ancestors = nodes["SAN"].ancestors
    node = nodes["YOU"].parent
    hops = 0

    while !node.nil? && !santa_ancestors.includes?(node)
      hops += 1
      node = node.parent
    end

    if node.nil?
      -1
    else
      hops + santa_ancestors[0...santa_ancestors.index(node)].size
    end
  end
end
