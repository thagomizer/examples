require "fog/google"

connection = Fog::Storage::Google.new

connection.put_bucket("pictures.thagomizer.com")

f = File.open("../goat.jpg")

connection.put_object("pictures.thagomizer.com", "my_picture", f)
