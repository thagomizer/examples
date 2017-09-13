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


require 'csv'
require 'pp'

def distance ary1, ary2
  paired_points = ary1.zip(ary2)

  Math.sqrt(paired_points.map { |a, b| (a - b)**2 }.inject(:+))
end

K = 5

data = CSV.read("iris.csv", converters: :all ).to_a

data.shift # Remove the header

new_iris = [5.0, 3.0, 4.4, 1.6, nil]

# Get the 3 irises in the data set that are closest to the new iris
neighbors = data.min_by(K) { |ary| distance new_iris[0..3], ary[0..3] }

pp neighbors.group_by { |a| a[4] }.max_by { |k, v| v.count }[0]
