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

require "gnuplot"
require "csv"
require "pp"

data = CSV.read("birth_counts.csv")
data.shift # Remove header row

years  = data.collect { |r| r[0].to_i }
births = data.collect { |r| r[1].to_f / 1_000_000  }

Gnuplot.open do |gp|
  Gnuplot::Plot.new( gp ) do |plot|

    plot.terminal "gif"
    plot.output File.expand_path("../birth_data.gif", __FILE__)

    plot.xrange "[1965:2010]"
    plot.title  "Births By Year"
    plot.ylabel "Births (Millions)"
    plot.xlabel "Year"

    plot.data << Gnuplot::DataSet.new( [years, births] ) do |ds|
      ds.with = "points"
      ds.notitle
    end


    x = (1965...2010).to_a
    y = x.map { |x| 0.064 * x - 123.634 }

    pp x.zip(y)

    plot.data << Gnuplot::DataSet.new( [x, y] ) do |ds|
      ds.with = "lines"
      ds.notitle
    end

  end
end
