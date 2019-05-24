require '../../config/environment'
require_relative 'processor'


### The directory containing our data files
SOURCE_DIR = Rails.root.join('files2')

# questionnaire = Questionnaire.create(quid: 1, description: "Questionario progetto collabora")
### Here we load the questions into the database

questionnaire = Questionnaire.first
qst_file = File.join(SOURCE_DIR, 'questionario_template.docx')
qprocessor = Processor.new(qst_file)
puts "number of questions: #{qprocessor.num_of_questions}"

1.upto(qprocessor.num_of_questions) do |qidx|
   question, note, subquestions = qprocessor.get_question(qidx)
   puts "=== Question #{qidx} ==="
   puts "Main question: #{question}"
   puts "Subquestions: #{subquestions.to_s}"
   puts "Note: #{note}"
   puts "========================"
   
## temporary comments ###    
  q = Question.new
  q.qid = qidx
  q.subid = 0
  q.qtext = question
  q.quid = questionnaire.quid
  q.save
   
  1.upto(subquestions.length) do |subidx|
      sq = Question.new
      sq.qid = qidx
      sq.subid = subidx
      sq.quid = questionnaire.quid
      sq.qtext = subquestions[subidx - 1]
      sq.save
    end   
##########################################

puts "==== Starting question options loading ===="
choices = qprocessor.get_question_choices(qidx)
question_id = qidx

1.upto(choices.length) do |idx|
  
        options = choices[idx - 1]
        options.each do |quest_opt|
           opt = QuestionOption.new
           opt.odescription = quest_opt
           opt.qid = qidx
           opt.subid = idx -1
           opt.save
           puts "Options"
           puts "Description: #{opt.odescription}, QID: #{opt.qid}, SUBID: #{opt.subid} "
       end
   
    end
end


puts "==== Questions loading completed! ===="



