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
