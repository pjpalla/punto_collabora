module SurveysHelper
    
    USER_KEYS = [:card_number, :collection_point, :sex, :eta]
    NUM_OF_INDICATORS = 11
    STRATUM = ["lc basso", "lc medio", "lc alto"]
    
    def session_processor(user_id)

       session_keys = session.keys.select{|key| key.to_s.match(/^answer*/)}
    #   logger.warn "session keys: #{session_keys}"
       answers = []
       drug_name = ""
       drug_category = ""
       dosage = ""
       1.upto(18) do |idx|
           if idx < 10
               pattern = "answer0" + idx.to_s + "_"
           else
               pattern = "answer" + idx.to_s + "_"
           end
        #   logger.warn "pattern: #{pattern}"
           ### Here we extract the note
           note_key = "#{pattern}note"
           answer_note = session[note_key.to_sym]
        #   logger.debug "answer_note: #{answer_note}"
           answer_text = ""

           for sid in 0..2 do
               key_subset = session_keys.select{|k| k.to_s.match(/^#{pattern}(\w+)?#{sid}$/)}
            #   logger.debug "sid: #{sid} key_subset: #{key_subset}"
           
               if key_subset.length == 0
                   next
               elsif key_subset.length == 1
                #   logger.debug "*** question 8"
                #   logger.debug "key_subset 8: #{key_subset}"
                   if (idx == 8 and sid == 1)
                    #   logger.warn "question 8 sid 1 condition"
                       answer_text = session[key_subset[0]].join(', ')
                   else   
                   answer_text = session[key_subset[0]]
                   end
                #   logger.debug "***elsif close - sid: #{sid}"
               else
                #   logger.debug("***else close - sid: #{sid}")
                   key_subset.each do |k|
                       if k.to_s.match(/(\w)+_drug_name_/)
                           drug_name = session[k]
                       elsif k.to_s.match(/(\w)+_drug_category_/)
                           drug_category = session[k]
                       else
                           dosage = session[k]
                       end
                   end
                   unless (drug_name.blank?) and (drug_category.blank?) and (dosage.blank?)
                        answer_text = "Farmaco: #{drug_name}, Categoria: #{drug_category}, Dosage: #{dosage}"
                   else
                        answer_text = ""
                   end        
               end
               ##here we buid the
               if sid != 0
                   answer_note = ""
               end       
               answer = Answer.new(answer: answer_text, qid: idx, subid: sid, uid: user_id, note: answer_note)
               answers << answer
           end   
       end    
       answers
    end
    
    def session_cleaner
        
        answer_keys = session.keys.select{|key| key.to_s.match(/^answer*/)}
        key_subset = USER_KEYS + answer_keys
        
        key_subset.each do |key|
            session.delete(key)
        end    
    end    
    
    
    def create_user
                ## User creation
        sex = session[:sex]
        age = session[:eta]
        collection_point = session[:collection_point]
        card = session[:card_number]
        s = session[:answer18_note].match(/LC (basso|medio|alto)/i) unless session[:answer18_note].nil?
        stratum = s[0].downcase unless s.nil?
        if !STRATUM.include?(stratum)
            stratum = ""
        end    
        user = User.create(sex: sex, age: age, collection_point: collection_point, card: card, stratum: stratum)
        return user.uid, sex, age, card 
    end
    
    def create_drug(sex, age)
        ###first we collect drug information from question 3
        drug_name = session[:answer03_drug_name_0]
        drug_category = session[:answer03_drug_category_0]
        drug_dosage = session[:answer03_dosage_0]
        ###then we get side effects from question 1 sub 1
        side_effects = session[:answer01_1]
        ##when you realized the effects - question 2
        elapsed_time = session[:answer02_0]
        unless drug_name.blank?
            drug = Drug.new(drug_name: drug_name, category: drug_category, dosage: drug_dosage, effect: side_effects, sex: sex, 
            age_range: age, elapsed_time: elapsed_time)
        else
            drug = ""
        end    
        drug
    end
    
    def count_indicators(uid, card)
       indicators = nil
       counter = Array.new(NUM_OF_INDICATORS, 0)
       session_note_keys = session.keys.select{|key| key.to_s.match(/(\w+)_note/)}
       
       session_note_keys.each do |key|
           note = session[key]
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
       ind_subset = ind.attributes.select{|k,v| k.to_s.match(/i[0-9]\d?/)}
       subset_values = ind_subset.values
       if subset_values.compact == 0
            ind = ""
       end
       return ind
    end
    
    def compose_answer(qid, subid)
        session_key = ""
        answer = ""
        if qid < 10
            #key_note = "answer0#{qid}_note".to_sym
            if (qid == 3 and subid == 0) or (qid == 4 and subid == 1) or (qid == 5 and subid == 1) or (qid == 7 and subid == 1)
                session_key1 = ("answer0#{qid}_drug_name_" + subid.to_s).to_sym
                session_key2 = ("answer0#{qid}_drug_category_" + subid.to_s).to_sym
                session_key3 = ("answer0#{qid}_dosage_" + subid.to_s).to_sym
                answer = session[session_key1] + " " + session[session_key2] + " " + session[session_key3]
            else   
                session_key = ("answer0#{qid}_" + subid.to_s).to_sym
                answer = session[session_key]
            end
        else
            #key_note = "answer#{qid}_note".to_sym
            if (qid == 11 and subid == 1)
                session_key1 = ("answer#{qid}_drug_name_" + subid.to_s).to_sym
                session_key2 = ("answer#{qid}_drug_category_" + subid.to_s).to_sym
                session_key3 = ("answer#{qid}_dosage_" + subid.to_s).to_sym
                answer = session[session_key1] + " " + session[session_key2] + " " + session[session_key3]                
            else
              #note = session[key_note]
              answer = session[session_key]
            end    
        end
        
        answer
    end
    
    def get_note(qid)
        key_base = "answer"
        if (qid < 10)
            key = "#{key_base}0#{qid}_note"
        else
            key = "#{key_base}#{qid}_note"
        end
        
        
        note = session[key.to_sym]
        logger.debug("key: #{key}")
        logger.debug("note: #{note}")
        return note
    end
end
