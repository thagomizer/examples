require "fog/google"

COMPUTE_ZONE = "us-central1-f"

connection = Fog::Compute::Google.new
flavor = connection.flavors.select { |f| f.zone == COMPUTE_ZONE and f.name == "f1-micro" }

server = connection.servers.bootstrap(:name => "my-new-server", :flavor => flavor)
