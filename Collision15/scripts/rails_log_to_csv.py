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
import sys

script, logfile, outfile = sys.argv

IP_RE = re.compile('(\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3})')
TIMESTAMP_RE = re.compile('\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}')
STATUS_RE = re.compile('Completed (\d{3})')
RESOURCE_RE = re.compile('Started (GET|POST|PUT|DELETE) "(.*?)"')
PROCESSING_TIME_RE = re.compile(' (\d+)ms')

records = []

with open(logfile, 'r') as f:
    for line in f:
        line = line.strip()
        if not line:
            continue

        d = {}

        d['body'] = line

        match                = IP_RE.search(line)
        d['ip_address']      = match.group()     if match else None

        match                = TIMESTAMP_RE.search(line)
        d['timestamp']       = match.group()     if match else None

        match                = STATUS_RE.search(line)
        d['status']          = match.group()     if match else None

        match                = PROCESSING_TIME_RE.search(line)
        d['processing_time'] = match.group()     if match else None

        match                = RESOURCE_RE.search(line)
        d['verb']            = match.groups()[0] if match else None
        d['resource']        = match.groups()[1] if match else None

        records.append(d)

with open(outfile, 'wb') as csvfile:
    logwriter = csv.writer(csvfile)
    logwriter.writerow(records[0].keys())
    for record in records:
        logwriter.writerow(record.values())
