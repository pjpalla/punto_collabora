require '../../config/environment'
require_relative 'processor'


### The directory containing our data files
SOURCE_DIR = Rails.root.join('filebb6')

## the array containing the names of our data files
data_files = Dir.entries(SOURCE_DIR)

data_files = data_files.delete_if {|f| f =~ /^(\.)+$/ }
data_files.sort!

recorded_files = User.pluck(:card)

data_files.each do |filename|
    
    file_id = filename.split(".")[0]
    if recorded_files.include?(file_id)
        puts "file #{filename} skipped"
        next
    end    
    
    file = File.join(SOURCE_DIR, filename)
    puts "**** filename: #{file} ****"
    processor = Processor.new(file)
    user_id = processor.get_user
    
    ##### Here we extract the qid and sub id of each question
    1.upto(processor.num_of_questions) do |idx|
        
        #subids = Subquestion.where(qid: idx).map {|s| s.subid}
        subids = Question.where(qid: idx).map {|q| q.subid}.select {|n| n !=0 }
        note = processor.get_note(idx)

        0.upto(subids.length) do |sid|
           puts "idx: #{idx}"    
           puts "sid: #{sid}"    
           res = processor.get_answer(idx, sid)
           answer_text = []        
           drug = nil
           if res.is_a? Array
               answer_text = res
            #   puts "answer_text: #{answer_text}*"
            #   drug = res[1]
           else
               answer_text << res
           end
############ Temporary solution #####
             answer_text.each do |an|
                unless sid != 0
                    #puts "sid = 0"
                    ##### Test 05
                    Answer.create(answer: an, qid: idx, subid: sid, uid: user_id, note: note)
                else
                    # puts "Question #{idx} - Sub: #{sid}"
                    # puts "answer: #{an}"
                    Answer.create(answer: an, qid: idx, subid: sid, uid: user_id)              
                end             
             end     
           
        end

####################################        
    
    
    end    
    

end