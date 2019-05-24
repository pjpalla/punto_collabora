require '../../config/environment'
require_relative 'processor'


# note = "i10: prima di prendere un farmaco, consulto sempre il bugiardino"


# indicators = note.scan(/i[1-9]\d?./)
# puts indicators
# counter = Array.new(11, 0)
#         indicators.each do |indicator|
#                         case indicator
#                             when /i1\D/ 
#                                 counter[0] += 1
#                             when /i2/
#                                 counter[1] += 1
#                             when /i3/
#                                 counter[2] += 1
#                             when /i4/ 
#                                 counter[3] += 1
#                             when /i5/
#                                 counter[4] += 1
#                             when /i6/
#                                 counter[5] += 1
#                             when /i7/
#                                 counter[6] += 1
#                             when /i8/
#                                 counter[7] += 1
#                             when /i9/
#                                 counter[8] += 1
#                             when /i10/
#                                 counter[9] += 1
#                             when /i11/
#                                 counter[10] += 1
                                
                                
                                
#                         end
                 
#                   end      


# print counter
# puts ""
# ### The directory containing our data files
SOURCE_DIR = Rails.root.join('files4')

#questionnaire = Questionnaire.create(quid: 1, description: "Questionario progetto collabora")
# ### Here we load the questions into the database

# #questionnaire = Questionnaire.first
qst_file = File.join(SOURCE_DIR, 'I0757.docx')
qprocessor = Processor.new(qst_file)
# #binding.pry

# ### Get question, subquestions and notes
q, n, subs = qprocessor.get_question(1)


# ## Question
puts "question: #{q}"
puts "subs: #{subs}"

# ## Note
# puts "note: #{qprocessor.get_note(8)}"


# # Question 8


# ### Subquestions

# subs.each do |s|
#     puts "subquestion: #{s}"
# end unless subs.nil?


# ## Answers

answer = qprocessor.get_answer(1, 1)
puts "answer: #{answer}"

# #user = qprocessor.get_user


# #puts "User: #{user}"
# # counter = Processor.get_indicators(2)
# # puts counter

# #Get indicators


# choices = qprocessor.get_question_choices(8)
# puts "choices: #{choices}"
# #puts "Choices"
# #puts choices[0]

# # n, c, d = qprocessor.get_drug(choice)
# # print n,c,d

# # puts "*** Get answer ****"


# #a =  qprocessor.get_answer(1,1)
# #puts "answer id: #{a.id}"
# #puts "answer text: #{a.answer}"
# #puts "answer: #{a}"

# #user = qprocessor.get_user
# #puts "user sex: #{user.sex}"

# # puts "Answer length: #{a.length}"
# # puts "is a Array?: #{a.is_a? Array}"

# # note = qprocessor.get_note(6)
# # puts "Note to question 6: #{note}"

