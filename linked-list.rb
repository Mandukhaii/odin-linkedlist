class Node
  attr_accessor :value, :next_node

  def initialize(value, next_node)
    @value = value
    @next_node = next_node
  end
end


class LinkedList

  attr_accessor :head

  def initialize
    #initializing an empty linked list
    @head = nil

    #this was creating an unnecessary extra empty node
    #@head = Node.new(nil, nil)
  end

  def prepend(value)
    #prepend sets the new head
    @head = Node.new(value, @head)
  end

  def append(value)
    if @head.nil?
      prepend(value)
    else
      tmp = @head
      while tmp.next_node
        tmp = tmp.next_node
      end
      tmp.next_node = Node.new(value, nil)
    end
  end
  
  def size
    count = 0
    tmp = @head

    while tmp
      count += 1
      tmp = tmp.next_node
    end
    count
  end

  def head
    @head.nil? ? nil : @head.value
  end

  def tail
    return nil if @head.nil?

    tmp = @head
    while tmp.next_node
      tmp = tmp.next_node
    end
    #assuming this is the last item
    tmp.value
  end

  def at(index)
    #to make the index start from 0
    iteration = 0

    tmp = @head

    while tmp
      return tmp.value if iteration == index
      tmp = tmp.next_node
      iteration += 1
    end
    "no item at index #{index}"
  end

  def pop
    if @head.nil?
      "can't delete"
    end

    cur = @head
    prev = nil

    while cur.next_node
      prev = cur
      cur = cur.next_node
    end
    prev.next_node = cur.next_node
  end

  def contains?(value)

    tmp = @head

    while tmp
      return true if tmp.value == value
      tmp = tmp.next_node
    end
    return false
  end

  def find(value)
    iteration = 0

    tmp = @head

    while tmp
      return iteration if tmp.value == value
      tmp = tmp.next_node
      iteration += 1
    end
    return "not found, no index"
  end

  def to_s
    result = []
    tmp = @head

    while tmp
      result << "( #{tmp.value} )"
      tmp = tmp.next_node
    end
    result.join(" -> ") + " -> nil"
  end
end


list = LinkedList.new

list.append('dog')
list.append('cat')
list.append('parrot')
list.append('hamster')
list.append('snake')
list.append('turtle')

puts "Linked list: #{list}"
puts "Size: #{list.size}"

#assuming the index starts from 0
puts "Linked list at index 2:  #{list.at(2)}"
puts "Linked list at index 10:  #{list.at(10)}"

puts "Linked list contains? turtle: #{list.contains?("turtle")}"
puts "Linked list contains? wolf: #{list.contains?("wolf")}"

puts "Find turtle's index in the list: #{list.find("turtle")}"

puts "LL head: #{list.head}"
puts "LL tail: #{list.tail}"

list.prepend("giraffe")
puts "Adding giraffe to the beginning: #{list}"

list.append("elephant")
puts "Adding elephant at the end: #{list}"

puts "New size: #{list.size}"
puts "LL new head: #{list.head}"
puts "LL at index 0: #{list.at(0)}"

list.pop
puts "Lastly, using pop to remove the last item: #{list}"
puts "New size: #{list.size}"