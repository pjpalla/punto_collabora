require '../../config/environment'

       NUM_OF_INDICATORS = 11

       all_answers = Answer.where("uid > 5875") ### Here we collect all notes
       uids = all_answers.map{|a| a.uid }.uniq
       indicators = nil
       
       #binding.pry
       #Let's iterate over notes
        
        uids.each do |uid|
           counter = Array.new(NUM_OF_INDICATORS, 0)
           card = User.where(uid: uid).pluck(:card)[0]
           ### seleziono le risposte relative a ciascun singolo intervistato    
           answers = all_answers.select{|a| a.uid == uid && a.subid == 0} 
    
           answers.each do |a|
      
              
              if a.uid == uid
                 note = a.note
                 indicators = note.scan(/i[1-9]\d?./)
                 indicators.each do |indicator|
                        case indicator
                            when /i1\D/ 
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
                            when /i9/
                                counter[8] += 1
                            when /i10/
                                counter[9] += 1
                            when /i11/
                                counter[10] += 1
                                
                                
                                
                        end
                 
                  end      
            
              end
     

           end
              ind = Indicator.new do |i|
                  i.uid = uid
                  i.card = card
                  i.i1 = counter[0]
                  i.i2 = counter[1]
                  i.i3 = counter[2]
                  i.i4 = counter[3]
                  i.i5 = counter[4]
                  i.i6 = counter[5]
                  i.i7 = counter[6]
                  i.i8 = counter[7]
                  i.i9 = counter[8]
                  i.i10 = counter[9]
                  i.i11 = counter[10]
              end #unless indicators.nil? || indicators.empty?
              
              #binding.pry
              ind.save #unless ind.nil?
 
        end    