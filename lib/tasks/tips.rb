require '../../config/environment'

# h = {"pippo" => 2, "io" => 1, "" => 3, "lillo" => 4}

# h.select{}
SOURCE_DIR = Rails.root.join('files4')
data_files = Dir.entries(SOURCE_DIR)

puts "Num of files: #{data_files.length}"
print data_files