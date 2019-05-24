require 'docx'
class Processor
    attr_reader :doc, :data
    
    @@questions_index = 4
    @@num_of_indicators = 8
    
    def initialize(doc_file)
       @doc = Docx::Document.open(doc_file) 
       @data = @doc.tables
       
    end
    
    def self.questions_index
        @@questions_index
    end
    
    def questions
        starting = Processor.questions_index
        ending = @data.length
        @questions = @data[starting..ending]
     end
     
     def num_of_questions
         questions = self.questions.values_at(* @questions.each_index.select {|i| i.even?})
         questions.length
     end
   ### Le domande del questionario hanno un indice compreso tra il numero 1 al numero 18 
    def get_question(num)
        ### Estraggo dall'array le sole domande trascurandeo le note
        questions = self.questions.values_at(* @questions.each_index.select {|i| i.even?})
        notes = self.questions.values_at(* @questions.each_index.select {|i| i.odd?})
        index =  num -1
        question_group = []
        subquestions = []
        
        block = questions[index].rows
        block.each do |row|
            text =  row.cells[0].text
            question_group << text if text =~ /\?/
         end

         question = question_group[0]
         subquestions = question_group[1..question_group.length]
         note = notes[index].rows[0].cells[0].text
         
         return question, note, subquestions
         
    end
    
    
    def get_note(num)
        #binding.pry
        notes = self.questions.values_at(* @questions.each_index.select {|i| i.odd?})
        #binding.pry        
        index = num -1
        note = notes[index].rows[0].cells[0].text

    end    
    
    
    def get_question_choices(num)
        questions = self.questions.values_at(* @questions.each_index.select {|i| i.even?})
        index =  num -1
        block = questions[index].rows
     
     
        block = block[1..block.length] if num == 5     
        text_vector = [] 
        block.each do |row|
             text =  row.cells[0].text
             text_vector << text
        end

        choices_group = []
        choices = []
        idx = 0
        text_vector.each do |t|
            t = t.strip unless t.nil?
            if t =~ /\?$/

                choices_group << choices unless choices.empty?
                choices = []
                idx += 1
                next
            end
            choices << t
            idx += 1
            if (idx == text_vector.length)
                choices_group << choices
            end    
        end    
                
        return choices_group    
    end
    
    
    def get_answer(num, sub_num = 0)
        
        
        if num == 18
            questions = self.questions.values_at(* @questions.each_index.select {|i| i.even?})
            index =  num - 1
            block = questions[index].rows
                answer =  block[1].cells[0].text
            return answer
        end    
            
        
        answer = nil
        answers = []
        choices = self.get_question_choices(num)
        puts "inside processor - sub_num: #{sub_num}"
        puts "choices_length: {choices.length}"
        
        if (sub_num < 0 || sub_num > (choices.length - 1))
  
            raise "Wrong sub question argument"
        end    
        
      
        group = choices[sub_num]
#        puts group.to_s
        
        if group.length == 1
            puts "single answer"
            answer = group[0]
    
            
        elsif group[0] =~ /nome/i
            puts "=== get_drug condition==="
            drug = []
            names, categories, dosages = self.get_drug(group) #### da modificare
            #v = [name, category, dosage]
            if is_empty?(names) && is_empty?(categories) && is_empty?(dosages)
                puts "empty answer"
                answer = nil
            else
                array_lengths = [names.length, categories.length, dosages.length]
                max_length = array_lengths.max
                answers = []
                0.upto(max_length - 1) do |i|
                    #binding.pry
                    puts "names[i]: #{names[i]} categories[i]: #{categories[i]}"

                    if (!names[i].nil? && !categories[i].nil? && names[i].strip == "-" && categories[i].strip == "-")
                        next
                    end    
                    answer = "Farmaco: #{names[i]}, Categoria: #{categories[i]}, Dosaggio: #{dosages[i]}"
                    answers << answer
                end    
                
                #answer = "Farmaco: #{name}, Categoria: #{category}, Dosaggio: #{dosage}"
                # if answers.length == 1
                #     puts "sigle drug: #{answers[0]}"
                #     return answers[0]
                    
                # else
                #     puts "multiple drugs"
                #     print answers
                #     puts "/n"
                #     return answers
                    
                # end
                return answers
            end
            #drug = name, category, dosage
  
            #return answer, drug
        else    
            group.each do |el|
               if el =~ /[xX]/
                   answer = el.gsub(/[xX]/, "")
                   answers << answer
                   #break # testing scelte multiple involontarie
                end       
            end
            if answers.length > 1
                return answers
            else    
                return answers[0]
            end    
        end

    
    end
    
    
    def get_drug(choice)
        values = []
        choice.each do |el|
            #values << el.split(" ")[1]
         
            choice_text = el.gsub(/(nome|categoria|dosaggio)/i, "")
            drug_data = choice_text.split(",").map{|w| w.strip}
            values << drug_data
          end    
        # puts values.to_s
        names = values[0] 
        categories = values[1]
        dosages = values[2]
        return names, categories, dosages 
    end
    
    
    
    def get_user
        #### the note to the 18th question contains
        #### socio-economic info about the users interviewed 
        note_index = 18 
        
        start = 0
        finish = @@questions_index - 1
        
        user_info = self.data[start..finish]
        
        # puts "User tables: #{user_info.length}"
        card = nil
        collection_point = nil
        age = nil
        sex = nil
        
        start.upto(finish) do |idx|
           case idx
           when 0
               card = user_info[idx].rows[1].cells[0].text
            #   puts "Card n° #{card}"
           when 1
               collection_point = user_info[idx].rows[1].cells[0].text
            #   puts "CP: #{collection_point}"
            
           when 2
               user_info[idx].rows.each do |row|
                    text = row.cells[0].text
                    sex = text.gsub(/[Xx]/, "") if text =~ /[xX]/
                    # puts sex
                end    
           when 3
               user_info[idx].rows.each do |row|
                   text = row.cells[0].text
                   age = text.gsub(/[Xx]/, "") if text =~ /[xX]/
                #   puts age
               end   
           end   
        end    
        
        stratum = self.get_note(note_index)
    
        ###Trasforma new in create    
        user = User.create(sex: sex, age: age, collection_point: collection_point, card: card, stratum: stratum)
        puts "user card: #{user.card}"
        #deve restituire uid
        return user.uid
        
    end
    
    def is_empty?(vect1)
        if vect1.compact.length == 0 || vect1.all?(&:empty?)
            return true
        else 
            return false
        end    
    end
    
    def self.get_indicators(num)
        counter = Array.new(@@num_of_indicators, 0)
        
        #note = self.get_note(num)
        note = "bla bla bla; i1: positivo; aahahha; i5: negativo; i1: positivo; lluuud"
        indicators = note.scan(/i[1-8]:\W?\w+/)
        indicators.each do |indicator|
            case indicator
                when /i1/ 
                    counter[0] += 1
                when /i2/
                    counter[1] += 1
                when /i3/
                    counter[2] += 1
                when /i4/ 
                    counter[3] += 1
                when /i5/
                    counter[4] += 1
                when /i6/
                    counter[5] += 1
                when /i7/
                    counter[6] += 1
                when /i8/
                    counter[7] += 1
            end    
            
        
        end    
        
        counter
    end    
        
    
    
end    
