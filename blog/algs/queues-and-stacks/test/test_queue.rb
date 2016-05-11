# Copyright 2016 Google
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at

#      http://www.apache.org/licenses/LICENSE-2.0

# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

require 'minitest/autorun'
require './queue'

class TestQueue < Minitest::Test
  def setup
    @queue = Queue.new
  end

  def test_enqueue_one_item
    @queue.enqueue 3
    assert_equal 3, @queue.dequeue
  end

  def test_equeue_and_dequeue
    @queue.enqueue 3
    @queue.enqueue 5

    assert_equal 3, @queue.dequeue
    assert_equal 5, @queue.dequeue
  end

  def test_empty?
    assert @queue.empty?
  end
end
