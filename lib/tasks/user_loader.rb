require '../../config/environment'
require_relative 'processor'


### The directory containing our data files
SOURCE_DIR = Rails.root.join('files3')

## the array containing the names of our data files
data_files = Dir.entries(SOURCE_DIR)

data_files = data_files.delete_if {|f| f =~ /^(\.)+$/ }
data_files.sort!

data_files.each do |filename|
    file = File.join(SOURCE_DIR, filename)
    processor = Processor.new(file)
    uid = processor.get_user
    puts "User #{uid} successfully saved to database"
end    