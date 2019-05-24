require '../../config/environment'
require_relative 'processor'


### The directory containing our data files
SOURCE_DIR = Rails.root.join('files')

# questionnaire = Questionnaire.create(quid: 1, description: "Questionario progetto collabora")
### Here we load the questions into the database


## the array containing the names of our data files
data_files = Dir.entries(SOURCE_DIR)


file = File.join(SOURCE_DIR, data_files[6])
puts "File considered: #{file}"

processor = Processor.new(file)
# current_doc = processor.doc

# questions = processor.questions
# q, n, sq = processor.get_question(1)



# puts "question: #{q}"
# puts "note: #{n}"
# puts "subquestion: #{sq}"


puts "====Method get_question_choices ====="
# choices_group = processor.get_question_choices(1)
# puts "question choices: "
# puts choices_group.to_s


puts "======= Method get_answer==="
#x = processor.get_answer(18)
#puts "answer type: #{x.is_a? Array}"
puts processor.get_note(10)

# puts processor.num_of_questions
# data_files.each do |f|
#     doc = Docx::Document.open(f)
# end

### Processing the 

# parse(data_files[0])

# puts "==== Method get_user ===="
# processor.get_user