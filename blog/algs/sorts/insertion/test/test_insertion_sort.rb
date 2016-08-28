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
require './insertion_sort'

class TestInsertionSort < Minitest::Test
  def test_sort_empty_list
    assert_equal [], [].insertion_sort
  end

  def test_sort_list_length_one
    assert_equal [3], [3].insertion_sort
  end

  def test_sort_random_list
    assert_equal [1, 2, 3, 4, 5], [3, 2, 5, 1, 4].insertion_sort
  end

  def test_sort_bang_empty_list
    ary = []
    ary.insertion_sort!
    assert_equal [], ary
  end

  def test_sort_bang_list_length_one
    ary = [3]
    ary.insertion_sort!
    assert_equal [3], ary
  end

  def test_sort_bang_random_list
    ary = [3, 2, 5, 1, 4]
    ary.insertion_sort!
    assert_equal [1, 2, 3, 4, 5], ary
  end
end
