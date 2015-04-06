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

SYSLOG_RE = re.compile(r"""
    (\w{3}\ {1,2}\d{1,2}\ \d{2}:\d{2}:\d{2}) # Timestamp
    \s([\w-]*)                               # Application
    \s([\w-]*)                               # Source
    \[(\w+)\]?                               # Optional pid
    :
    (.*)                                     # Details
    """, re.VERBOSE)

records = []

with open(logfile, 'r') as f:
    for line in f:
        line = line.strip()
        if not line:
            continue

        d = {}

        match = SYSLOG_RE.search(line)
        if match:
            groups = match.groups()
            d['timestamp'] = groups[0]
            d['app']       = groups[1]
            d['source']    = groups[2]
            d['pid']       = groups[3]
            d['details']   = groups[4]

        d['raw'] = line
        records.append(d)

with open(outfile, 'wb') as csvfile:
    logwriter = csv.writer(csvfile)
    logwriter.writerow(records[0].keys())
    for record in records:
        logwriter.writerow(record.values())
