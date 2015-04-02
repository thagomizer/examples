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

import re
import csv
from sys import argv

_, logfile, outfile = argv

ip_regex = re.compile('(\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3})')
timestamp_regex = re.compile('\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}')
status_regex = re.compile('Completed (\d{3})')
resource_regex = re.compile('Started (GET|POST|PUT|DELETE) "(.*?)"')
processing_time_regex = re.compile(' (\d+)ms')

records = []

f = open(logfile)

for line in iter(f):
    line = line.strip()
    if not line:
        continue

    d = {'body':None, 'ip_address':None, 'timestamp':None, 'status':None,
         'processing_time':None, 'verb':None, 'resource':None}

    d['body'] = line

    ms = ip_regex.findall(line)
    if ms:
        d['ip_address'] = ms[0]

    ms = timestamp_regex.findall(line)
    if ms:
        d['timestamp'] = ms[0]


    ms = status_regex.findall(line)
    if ms:
        d['status'] = ms[0]

    ms = processing_time_regex.findall(line)
    if ms:
        d['processing_time'] = ms[0]

    ms = resource_regex.findall(line)
    if ms:
        d['verb'] = ms[0][0]
        d['resource'] = ms[0][1]

    records.append(d)

f.close()

with open(outfile, 'wb') as csvfile:
    logwriter = csv.writer(csvfile)
    logwriter.writerow(records[0].keys())
    for record in records:
        logwriter.writerow(record.values())
