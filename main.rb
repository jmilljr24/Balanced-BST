class Node
  attr_accessor :data, :left_child, :right_child

  def initialize(data, left_child = nil, right_child = nil)
    @data = data
    @left_child = left_child
    @right_child = right_child
  end
end

class Tree
  attr_accessor :root, :data

  def initialize(array)
    @data = array.sort.uniq
    @root = build_tree(data)
  end

  def build_tree(array)
    mid = (array.size - 1) / 2
    root_node = Node.new(array[mid])
    p root_node
  end
end

list = [1, 10, 4, 5, 6, 5, 8, 2, 12]

bst = Tree.new(list)
