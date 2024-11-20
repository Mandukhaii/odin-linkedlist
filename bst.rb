# module Comparable
#   def compare(a, b)
#   # -1 if self is less than other
#   # 0 if self is equal to other
#   # 1 if self is greater than other
#    a <=> b
#   end
# end

class Node
  # include Comparable

  attr_accessor :data, :left, :right
  
  def initialize(data)
    @data = data
    @left = nil
    @right = nil
  end
end

class Tree

  attr_accessor :root

  def initialize(arr)
    @root = build_tree(arr)
  end

  def build_tree(arr)
    sorted_arr = arr.sort.uniq
    
    n = sorted_arr.length
    return nil if n == 0

    #create the root node
    mid = (n - 1) / 2 
    root = Node.new(sorted_arr[mid])

    q = [[root, [0, n - 1]]]

    while !q.empty?
      curr, (s, e) = q.shift
      index = s + (e - s) / 2

      #if left subtree exists
      if s < index
        mid_left = s + (index - 1 - s) / 2
        left = Node.new(sorted_arr[mid_left])
        curr.left = left
        q.push([left, [s, index - 1]])
      end

      if e > index
        mid_right = index + 1 + (e - index - 1) / 2
        right = Node.new(sorted_arr[mid_right])
        curr.right = right
        q.push([right, [index + 1, e]])
      end
    end

    return root

  end

  def pretty_print(node = @root, prefix = '', is_left = true)
    pretty_print(node.right, "#{prefix}#{is_left ? '│   ' : '    '}", false) if node.right
    puts "#{prefix}#{is_left ? '└── ' : '┌── '}#{node.data}"
    pretty_print(node.left, "#{prefix}#{is_left ? '    ' : '│   '}", true) if node.left
  end

  def insert(key, node = @root)
    return Node.new(key) if node.nil?

    return node if node.data == key

    if key < node.data
      node.left = insert(key, node.left)
    else
      node.right = insert(key, node.right)
    end

    node
  end

  def delete(key, node = @root)

    #base case
    return node if node.nil?

    if node.data > key
      node.left = delete(key, node.left)
    elsif node.data < key
      node.right = delete(key, node.right)
    else
      return node.right if node.left.nil?
      return node.left if node.right.nil?

      s = get_successor(node)
      node.data = s.data
      node.right = delete(s.data, node.right)
    end
    node
  end

  def find(key, node=@root)
    
    return nil if node.nil?
    return node if node.data == key

    if key < node.data
      return find(key, node.left)
    end

    if key > node.data
      return find(key, node.right)
    end
  end

  #breadth-first traversal
  def level_order(node = @root, elements = [])
    return elements if node.nil?

    # initialize the queue (array) with the root node
    queue = [node]  

    while !queue.empty?
      #dequeue the first node
      current_node = queue.shift
      elements << current_node.data 

      #add the left and right children if they exist
      queue << current_node.left if current_node.left
      queue << current_node.right if current_node.right
    end

    elements
  end

  # left - root - right
  def inorder(node=@root, elements=[])
    return elements if node.nil?

    inorder(node.left, elements)
    elements << node.data
    inorder(node.right, elements)

    elements
  end

  # root - left - right
  def preorder(node=@root, elements=[])
    return elements if node.nil?

    elements << node.data
    preorder(node.left, elements)
    preorder(node.right, elements)
  end

  #left - right - root
  def postorder(node=@root, elements=[])
    return elements if node.nil?

    postorder(node.left, elements)
    postorder(node.right, elements)
    elements << node.data
  end

  #height is defined as the number of edges in longest path from a given node to a leaf node
  def height(key, node=@root)
    @height = nil
    height_helper(key, node)
    @height.nil? ? - 1 : @height
  end

  #depth is defined as the number of edges in path from a given node to the tree’s root node
  def depth(key, node=@root)
    return -1 if node.nil?

    dist = -1

    if node.data == key
      return dist + 1
    end

    dist = depth(key, node.left)
    if dist >= 0
      return dist + 1
    end

    dist = depth(key, node.right)
    if dist >= 0
      return dist + 1
    end

    return dist
  end

  def balanced?
    check_balance(@root) != false
  end

  def rebalance()
    elements = inorder()
    @root = build_tree(elements)
  end

  private
  def height_helper(key, node)
    return -1 if node.nil?

    left_height = height_helper(key, node.left)
    right_height = height_helper(key, node.right)

    height = [left_height, right_height].max + 1

    if node.data == key
      @height = height
    end

    height
  end

  def get_successor(curr)
    curr = curr.right
    while !curr.nil? && !curr.left.nil?
      curr = curr.left
    end
    curr
  end

  def check_balance(node)
    return 0 if node.nil?

    left_height = check_balance(node.left)
    right_height = check_balance(node.right)

    return false if left_height == false || right_height == false
    return false if (left_height - right_height).abs > 1

    [left_height, right_height].max + 1
  end
  
end

#driver script
arr = (Array.new(15) { rand(1..100) })
tree = Tree.new(arr)
puts "Tree balanced?: #{tree.balanced?}"
tree.pretty_print()
puts "Level order: #{tree.level_order().join(" - ")}"
puts "Preorder: #{tree.preorder().join(" - ")}"
puts "Postorder: #{tree.postorder().join(" - ")}"
puts "Inorder: #{tree.inorder().join(" - ")}"
tree.insert(150)
tree.insert(145)
tree.insert(175)
puts "Tree balanced?: #{tree.balanced?}"
tree.pretty_print()
tree.rebalance()
puts "Tree balanced?: #{tree.balanced?}"
tree.pretty_print()
puts "Level order: #{tree.level_order().join(" - ")}"
puts "Preorder: #{tree.preorder().join(" - ")}"
puts "Postorder: #{tree.postorder().join(" - ")}"
puts "Inorder: #{tree.inorder().join(" - ")}"

