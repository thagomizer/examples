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

require "fog/google"

COMPUTE_ZONE = "us-central1-f"
MACHINE_TYPE = "f1-micro"

connection = Fog::Compute::Google.new

disk = connection.disks.create(
  :name => "new-disk",
  :size_gb => 10,
  :zone_name => COMPUTE_ZONE,
  :source_image => "debian-8-jessie-v20161020")

puts "Creating disk"

disk.wait_for { disk.ready? }

puts "Disk ready"

server = connection.servers.create(
  :name => "new-server",
  :disks => [disk],
  :machine_type => MACHINE_TYPE,
  :private_key_path => File.expand_path("~/.ssh/id_rsa"),
  :public_key_path => File.expand_path("~/.ssh/id_rsa.pub"),
  :zone_name => COMPUTE_ZONE,
  :user => ENV["USER"],
  :tags => ["fog"])

puts "Creating server"

server.wait_for { server.ready? }

puts "Server ready"
