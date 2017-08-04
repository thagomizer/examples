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

require 'descriptive_statistics'
require 'csv'
require 'pp'

module DescriptiveStatistics
  def variance(collection = self, &block)
    values = Support::convert(collection, &block)
    return DescriptiveStatistics.variance_empty_collection_default_value if values.empty?

    mean = values.mean
    values.map { |sample| (mean - sample) ** 2 }.reduce(:+) / (values.number - 1)
  end
end

class Array
  def sum
    inject(&:+)
  end
end

### Covariance
## Cov(x,y) = (Sum(x - x_mean)(y - y_mean))/n -1
def covariance x, y
  x_bar = x.mean
  y_bar = y.mean

  x.zip(y).map { |(x1, y1)| (x1 - x_bar) * (y1 - y_bar) }.sum / (x.length - 1)
end

## Pearson's Correlation
## Cov(x,y) / (sd_x)(sd_y)
def pearson_correlation x, y
  x_sd = x.standard_deviation
  y_sd = y.standard_deviation

  cov = covariance x, y
  cov / (x_sd * y_sd)
end

data = CSV.read("birth_counts.csv")
data.shift

years, births = data.transpose

births.map! { |x| x.to_f / 1_000_000 }
years.map! { |x| x.to_i }

puts "YEARS"
puts years

puts "BIRTHS"
puts births

births_mean = births.mean
years_mean  = years.mean

pp "X Mean: #{years_mean}"
pp "Y Mean: #{births_mean}"

births_sd = births.standard_deviation
years_sd  = years.standard_deviation

pp "X SD: #{years_sd}"
pp "Y SD: #{births_sd}"

## Pearson's Correlation
## Cov(x,y) / (sd_x)(sd_y)

cov = covariance(births, years)

r = cov / (births_sd * years_sd)

puts "r #{r}"

## Correlation Line
## y = mx + b
##
## m = r*(sd_x/sd_y)
## b = y_mean - b * x_mean

m = r * (births_sd / years_sd)

puts "m #{m}"

b = births_mean - m * years_mean

puts "b #{b}"

puts "Linear Regression Equation: y = #{m.round(3)}x + #{b.round(3)}"

puts "For 2008: #{m.round(3) * 2008 + b.round(3)}"
puts "For 2050: #{m.round(3) * 2050 + b.round(3)}"
puts "For 2020: #{m.round(3) * 2020 + b.round(3)}"
