class Node
  attr_accessor :data, :left, :right

  def initialize(data)
    @data = data
    @left = nil
    @right = nil
  end
end

class Tree
  attr_accessor :root, :data

  def initialize(array)
    @data = array.sort.uniq
    @root = build_tree(data)
    @arr = []
  end

  def build_tree(array)
    return nil if array.empty?

    mid = (array.size - 1) / 2
    root_node = Node.new(array[mid])
    root_node.left = build_tree(array[0...mid])
    root_node.right = build_tree(array[(mid + 1)..-1])

    root_node
  end

  def insert(value, node = root)
    return nil if value == node.data

    # if value is < the root node move to left child
    # if left child is nil, insert value else check new root node for greater or less than
    if value < node.data
      node.left.nil? ? node.left = Node.new(value) : insert(value, node.left)
    else
      node.right.nil? ? node.right = Node.new(value) : insert(value, node.right)
    end
  end

  def delete(value, node = root)
    return node if node.nil?

    if value < node.data # move left
      node.left = delete(value, node.left)
    elsif value > node.data # move right
      node.right = delete(value, node.right)
    else # one or no child
      return node.left if node.right.nil?
      return node.right if node.left.nil?

      # two children
      key = left_most(node.right)
      node.data = key.data
      node.right = delete(key.data, node.right)
    end
    node
  end

  def left_most(node)
    node = node.left until node.left.nil?
    node
  end

  def find(value, node = root)
    return node if node.nil? || node.data == value

    value < node.data ? find(value, node.left) : find(value, node.right)
  end

  def level_order(node = root)
    return if node.nil?

    queue = []
    list = []
    queue << node
    until queue.empty?
      current = queue[0]
      list << current.data
      yield current if block_given?
      queue << current.left unless current.left.nil?
      queue << current.right unless current.right.nil?
      queue.shift
    end
    return list unless block_given?
  end

  def pre_order(node = root, list = [], &block)
    return if node.nil?

    if block_given?
      yield node
      pre_order(node.left, &block)
      pre_order(node.right, &block)

    else
      list << node.data
      pre_order(node.left, list)
      pre_order(node.right, list)
    end
    return list if !block_given? && node == root
  end

  def in_order(node = root, list = [], &block)
    return if node.nil?

    if block_given?
      in_order(node.left, &block)
      yield node
      in_order(node.right, &block)
    else
      in_order(node.left, list)
      list << node.data
      in_order(node.right, list)
    end
    return list if !block_given? && node == root
  end

  def post_order(node = root, list = [], &block)
    return if node.nil?

    if block_given?
      post_order(node.left, &block)
      post_order(node.right, &block)
      yield node
    else
      post_order(node.left, list)
      post_order(node.right, list)
      list << node.data
    end
    return list if !block_given? && node == root
  end

  def height(node = root)
    return -1 if node.nil?

    left_height = height(node.left)
    right_height = height(node.right)
    left_height > right_height ? left_height + 1 : right_height + 1
  end

  def depth(node = root, key)
    return -1 if node.nil?

    dist = -1
    if node.data == key || (dist = depth(node.left, key)) >= 0 || (dist = depth(node.right, key)) >= 0
      return dist + 1
    end

    dist
  end

  def balanced?(node = root)
    return true if node.nil?

    lh = height(node.left)
    rh = height(node.right)

    return false if (lh - rh).abs > 1

    balanced?(node.left) && balanced?(node.right)
  end

  def rebalance
    @root = build_tree(level_order)
  end

  # Prints the node tree
  def pretty_print(node = @root, prefix = '', is_left = true)
    pretty_print(node.right, "#{prefix}#{is_left ? '│   ' : '    '}", false) if node.right
    puts "#{prefix}#{is_left ? '└── ' : '┌── '}#{node.data}"
    pretty_print(node.left, "#{prefix}#{is_left ? '    ' : '│   '}", true) if node.left
  end
end

# list = [1, 3, 2, 0, 4, 5, 6, 7, 8, 9, 11, 12, 13, 14, 15, 16]

tree = Tree.new(Array.new(15) { rand(1..100) })
tree.pretty_print

puts "Balanced?: #{tree.balanced?}" # return false

puts "Level order: #{tree.level_order}"
puts "Preorder: #{tree.pre_order}"
puts "Inorder: #{tree.in_order}"
puts "Postorder: #{tree.post_order}"

tree.insert(101)
tree.insert(105)
tree.insert(109)
tree.insert(110)
puts 'Inserting 101, 105, 109, 110'
puts "Balanced?: #{tree.balanced?}" # return false

tree.pretty_print

tree.rebalance
puts 'Rebalancing...'
puts "Balanced?: #{tree.balanced?}" # return true

tree.pretty_print
puts "Level order: #{tree.level_order}"
puts "Preorder: #{tree.pre_order}"
puts "Inorder: #{tree.in_order}"
puts "Postorder: #{tree.post_order}"
