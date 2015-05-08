# Copyright 2015 Google
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at

#      http://www.apache.org/licenses/LICENSE-2.0

# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# encoding: UTF-8

require 'csv'
require 'time'

filename, outfile, * = ARGV

abort "Specify outfile" unless outfile

NGINX_REGEX = /(\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}) - - \[(.*)\] "([A-Z]+) (\S*) (\S*)" (\d{3}) (.*)/


Record = Struct.new(:ip_address, :timestamp, :verb, :body,
                    :path, :protocol, :status, :details)

records = []

File.open(filename, "r:UTF-8").each_line do |line|
  line.chomp!
  next if line.empty?
  r = Record.new
  r.body = line

  match = NGINX_REGEX.match(line)

  if match
    r.ip_address = match[1]
    r.timestamp  = match[2] # formating
    r.verb       = match[3]
    r.path       = match[4]
    r.protocol   = match[5]
    r.status     = match[6]
    r.details    = match[7]

    ts = r.timestamp.split(/[\/: ]/)
    r.timestamp = Time.new(ts[2], ts[1], ts[0], ts[3], ts[4], ts[5]).iso8601
  end

  records << r
end

CSV.open(outfile, "wb:UTF-8") do |csv|
  csv << Record.members
  records.each do |row|
    csv << row.to_a
  end
end
