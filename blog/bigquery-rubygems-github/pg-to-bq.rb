require 'pg'
require 'gcloud'

ENV["GOOGLE_CLOUD_PROJECT"] = "rubygems-bigquery"
ENV["GOOGLE_CLOUD_KEYFILE"] = ""

gcloud   = Gcloud.new
bigquery = gcloud.bigquery
dataset  = bigquery.dataset "rubygems"

conn = PG.connect dbname: 'rubygems'

# Gems
table    = dataset.table("gems")
unless table then
  table ||= dataset.create_table("gems", name: "gems", description: "The list of all rubygems") do |schema|
    schema.integer   "id"
    schema.string    "name"
    schema.timestamp "created_at"
    schema.timestamp "updated_at"
  end
end

rubygems_cols = %w[id name created_at updated_at]

conn.exec("SELECT * FROM rubygems") do |result|
  result.each do |row|
    data = Hash[rubygems_cols.zip(row.values)]
    table.insert(data, skip_invalid: true, ignore_unknown: true)
  end
end
