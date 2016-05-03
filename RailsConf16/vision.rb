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

require "gcloud/vision"

ENV["TRANSLATE_KEY"] = "AIzaSyAC7YsjoFHTMmsHTbEcgvPnNL7vNKYN_VA"
ENV["GOOGLE_CLOUD_PROJECT"] = "postcards-from-gorby"
ENV["GOOGLE_CLOUD_KEYFILE"] = "/Users/ajahammerly/examples/RailsConf16/private-key.json"

gc = Gcloud.new

v = gc.vision
i = v.image "./postcard-one.jpg"
a = v.annotate i, landmarks: 1

puts "Description:"
puts a.landmark.description
puts
puts "Location:"
puts a.landmark.locations

puts


i = v.image "./postcard-two.jpg"
a = v.annotate i, labels: 10
a.labels.each { |l| puts l.description }


puts

v = gc.vision
i = v.image "./postcard-three.jpg"
a = v.annotate i, text: 1

puts "Text"
puts a.text.text
puts
puts "Locale"
puts a.text.locale

puts

puts "Translating"
t = gc.translate
text = a.text.text
translation = t.translate text, from: a.text.locale, to: "en"
puts translation.text


i = v.image "./postcard-five.jpg"
a = v.annotate i, landmarks: 1

puts "Description:"
puts a.landmark.description
puts "Location:"
puts a.landmark.locations
