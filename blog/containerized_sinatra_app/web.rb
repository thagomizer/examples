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

require 'sinatra'
require 'haml'
require "gcloud"

set :bind, '0.0.0.0'

get '/' do
  "Updated"
end

get "/upload" do
  haml :upload
end

# Handle POST-request (Receive and save the uploaded file)
post "/upload" do
  gcloud = Gcloud.new "zinc-computer-124720", "service-account-key.json"
  storage = gcloud.storage

  bucket = storage.bucket "zinc-computer-124720"

  bucket.create_file params['myfile'][:tempfile], params['myfile'][:filename]

  return "The file was successfully uploaded!"
end
