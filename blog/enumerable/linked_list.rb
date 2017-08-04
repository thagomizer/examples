# Copyright 2017 Google
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at

#      http://www.apache.org/licenses/LICENSE-2.0

# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

class Node
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
    n = Node.new value

    if @tail
      @tail.next = n
    else
      @head = n
    end

    @tail = n
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
