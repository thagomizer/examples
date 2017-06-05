class Cell
  attr_accessor :value, :next

  def initialize value
    @value = value
    @next = nil
  end
end

class LinkedList
  attr_accessor :head, :tail

  def initialize
    @head = nil
    @tail = nil
  end

  def push value
    c = Cell.new value

    if @tail
      @tail.next = c
    else
      @head = c
    end

    @tail = c
  end

  def pop
    raise "Empty List" unless @head
    v = @head.value
    @head = @head.next
    v
  end

  def each
    node = @head

    while node do
      yield node
      node = node.next
    end
  end
end

l = LinkedList.new

l.push 5
l.push 7

puts "#{l.pop} should be 5"
l.push 12
l.push 10
puts "#{l.pop} should be 7"

puts "each block"

l.each do |i|
  puts i.value
end

puts "#{l.pop} should be 12"
