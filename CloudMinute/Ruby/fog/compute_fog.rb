require "fog/google"

COMPUTE_ZONE = "us-central1-f"
MACHINE_TYPE = "f1-micro"

connection = Fog::Compute::Google.new

disk = connection.disks.create(
  :name => "new-disk",
  :size_gb => 10,
  :zone_name => COMPUTE_ZONE,
  :source_image => "debian-8-jessie-v20161020")

disk.wait_for { disk.ready? }

server = connection.servers.create(
  :name => "new-server",
  :disks => [disk],
  :machine_type => MACHINE_TYPE,
  :private_key_path => File.expand_path("~/.ssh/id_rsa"),
  :public_key_path => File.expand_path("~/.ssh/id_rsa.pub"),
  :zone_name => COMPUTE_ZONE,
  :user => ENV["USER"],
  :tags => ["fog"])

server.wait_for { server.ready? }
