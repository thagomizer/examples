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

require "pp"
require "irb"

words = File.read("Fairy Tales.txt").split(/(\b)/).map{ |x| x.sub(/\s+/,"")}.reject(&:empty?)

frequencies = Hash.new { |h, k| h[k] = Hash.new(0) }

words.each_cons(2) do |w1, w2|
  frequencies[w1.downcase.to_sym][w2.to_sym] += 1
end

probabilities = {}

frequencies.each do |w, h|
  total = h.values.inject(:+)

  p = 0.0
  h.each do |k, v|
    h[k] = v/total + p
    p = h[k]
  end

  frequencies[w] = h.invert

  probabilities[w] = lambda do
    frequencies[w][frequencies[w].keys.bsearch { |x| x >= rand }]
  end
end

generated = [words.sample]

100.times do
  if probabilities[generated.last]
    next_word = probabilities[generated.last].call
  else
    next_word = probabilities.keys.sample
  end
  generated << next_word
end

pp generated.join(" ")
