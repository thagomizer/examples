require 'rinda/tuplespace'

URI = ARGV[0] || "druby://0.0.0.0:61676"
DRb.start_service(URI, Rinda::TupleSpace.new)
DRb.thread.join
