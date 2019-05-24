module QuestionsHelper
    
    

        
    
    QUESTION_IDX = [1,2,3,4,5,6,7]
   
    def sub_count(qid, subid)
        total = []
        qone = get_reference_question(qid)
        
        parent_one = 1
        Answer.where("qid = ? and  subid = ?", qid, subid).each do |a|
            if QUESTION_IDX.include? qid
                #parent_ans = Answer.where(qid: parent_one, subid: 0, uid: a.uid)[0].answer
                parent_ans = qone[a.uid]
                #logger.debug "parent answer: #{parent_ans}"
                if parent_ans =~ /no/ || parent_ans.nil?
                     #logger.debug "inside if"
                     next
                end

            end
            total << a.answer           
        end
        #logger.debug "total length: #{total.length}"
        counts = Hash.new 0
        count_drugs = Hash.new 0
        count_categories = Hash.new 0
        
        
        total.each do |resp|
            resp = resp.downcase unless resp.nil?
            resp.nil? ? resp = "nessuna risposta" : resp.strip!
            if resp =~ /^farmaco/
                resp_vect = resp.split(",").map{|w| w.downcase}
                drug = resp_vect[0].gsub("farmaco: ", "").strip
                category = resp_vect[1].gsub("categoria: ", "").strip
                #binding.pry
              unless drug.nil? || drug == "" || drug == "-"
                    drug = sanitize_drug_name(drug)
                    count_drugs[drug] += 1
              end   
              unless category.nil? || category == "" || category == "-"
                    count_categories[category] += 1
              end
            end

            counts[resp] += 1
        end
        
        qoptions = QuestionOption.where(qid: qid, subid: subid).map{|opt| opt.odescription.strip}
        count_keys = counts.keys
        
        qoptions.each do |opt|
            next if count_keys.include? opt
            counts[opt] = 0
        end    
                
        
        counts.except!("nessuna risposta") if (qid == 11 && subid == 2) || (qid == 6 && subid == 1)
        #binding.pry
        count_drugs = filter_counts(count_drugs, 0)
        ##here we sort by value in descending order
        count_drugs = (count_drugs.sort_by{|drug, count| -count}).to_h
        count_categories = filter_counts(count_categories, 0)
        count_categories = (count_categories.sort_by{|category, count| -count}).to_h
        return counts, count_drugs, count_categories
    end  
    
    
  def get_reference_question(qid)
        question_id = case qid
        when 1..7 then 1
        when 9..10 then 9
        end    
        
        q = Answer.where(qid: question_id, subid: 0)
        h = Hash.new 0
        q.each do |a|
            h[a.uid] = a.answer
        end
        return h
  end 
  
  
  def filter_counts(counts, threshold = 1)
            w = counts.select{|k, v| v > threshold}
  end
  
  
  
  def get_prescriber(qid, subid)
    if qid != 8
        return
    end
    total = []
    total = Answer.where(qid: 8, subid: 1).map {|a| a.answer}
    
    count_prescriber = Hash.new 0
    count_changer = Hash.new 0
    count = Hash.new 0
    
    total.each do |resp|
        next if resp.nil? || resp == ""
        resp_vect = resp.split(",")
        logger.warn "resp_vect: #{resp_vect}"
        
        prescriber = resp_vect[0].strip.downcase unless resp_vect[0].nil?
        changer = resp_vect[1].strip.downcase unless resp_vect[1].nil?
        
        count_prescriber[prescriber] += 1
        count_changer[changer] += 1
        count[resp.downcase] += 1
   
    end
    
    count_prescriber = filter_counts(count_prescriber)
    count_changer = filter_counts(count_changer)
    #binding.pry
    return count_prescriber, count_changer, count

  end 
  
  def get_suggestions(qid)
      answers = Answer.where(qid: 18).map{|a| a.answer}
      answers = answers.reject{|a| a == ""}
  end
  
  def sanitize_drug_name(drug)
     wrong_to_corr = {"chetoprofene" => "ketoprofene", "paracetamolo generico" => "paracetamolo", 
     "enn" => "en", "efferalgan gusto pompelmo" => "efferalgan", "loperamide hexal" => "loperamide", 
     "ibuprofene generico" => "ibuprofene","atovarstatina" => "atorvastatina", "moment act" => "momentact"}
     
     if wrong_to_corr.keys.include? drug
         drug = wrong_to_corr[drug]
     end     
     drug    
  end    
    
    
end
