module StaticsHelper
    
    LOWER_INDICATOR = 1
    UPPER_INDICATOR = 11
    
def get_i(n)
    ### Card ranges for indicators i1 - 18
    frange = ("F1016".."F1252") ### franci - 217
    irange = ("I1081".."I1552") ## ila - 380
    brange = ("B0001".."B0317") ##bb - 157
  
    
    ### Card range for indicators i9, i10, i11
    card_range1 = ("I1262".."I1552") ##204
    card_range2 = ("B0168".."B0317") ##68
    
    
    indicator = "i"
    unless n < LOWER_INDICATOR || n > UPPER_INDICATOR
        indicator += n.to_s
    else
        raise ArgumentError, "invalid statistical indicator!"
    end    
    
    
    i = nil
   if (indicator == "i9" || indicator == "i10" || indicator == "i11")
      i = Indicator.where("card between ? and ? or card between ? and ?", 
      card_range1.first, card_range1.last, card_range2.first, card_range2.last).select(indicator).group("#{indicator}").count 
       #i = Indicator.where(card: card_range).select(indicator).group("#{indicator}").count
   else
    #   i_f = Indicator.where(card: frange).select(indicator).group("#{indicator}").count
    #   i_i = Indicator.where(card: irange).select(indicator).group("#{indicator}").count
    #   i_b = Indicator.where(card: brange).select(indicator).group("#{indicator}").count

    #   i = {0 => 0, 1 => 0}
    #   i[0] = i_f[0] + i_i[0] + i_b[0]
    #   i[1] = i_f[1] + i_i[1] + i_b[1]
       #binding.pry
      i = Indicator.where("card between ? and ? or card between ? and ? or card between ? and ?", 
      frange.first, frange.last, irange.first, irange.last, brange.first, brange.last).select(indicator).group("#{indicator}").count  
      #i = Indicator.where(card: global_range).select(indicator).group("#{indicator}").count
   end           
   #rimappiamo le chiavi dell'hash i
   if (i.keys().length > 2)
       sum_keys = 0
       i.keys().each do |k|
           if k != 0
               sum_keys += i[k]
           end
        #binding.pry   
        end    
        i[1] = sum_keys
        i.slice!(0, 1)
   end    
           
   remap = {0 => "invariato", 1 => "positivo"}
   
#   if(n == 9)
#       ###questionari barbara
#       ### il calcolo dell'indicatore i9 avviene in questo modo:
#       ### i9positivi = i9BB(con valore 1) + i9Range(con valore 1) / (totBB + totRange) 
#       ### 
#       bb_count = Indicator.where("card like 'B%'").count
#       i5_positive = Indicator.where("card like 'B%' and i9 = 1").count
#       i[0] = i[0] + bb_count - i5_positive
#       i[1] = i[1] + i5_positive
#   end       
   if (n == 8)
       remap = {0 => "", 1 => "suggerimento"}
   elsif (n == 10 || n == 11)
       remap = {0 => "no", 1 => "sì"}
   end       
   new_i = i.map{|k,v| [remap[k], v]}.to_h
   #binding.pry
   
end


def get_i_by_genre(n)
    ###Selezioniamo gli id degli utenti con i1 positivo
    indicator = "i"
    unless n < LOWER_INDICATOR || n > UPPER_INDICATOR
        indicator += n.to_s
    else
        raise ArgumentError, "invalid statistical indicator!"
    end    
    uids = Indicator.where("#{indicator} = 1").pluck(:uid)
    i_genre = User.select('sex').where(uid: uids).group(:sex).count
    
    if i_genre.keys.length == 1
        if !(i_genre.keys.include? "F")
            i_genre["F"] = 0
        else
            i_genre["M"] = 0     
        end
    end
    i_genre
    #binding.pry
    
end

def get_stacked_data
        w = Answer.select('uid').distinct.where("qid = 5 and answer <> ''").map{|a| a.uid}
        males =  User.where(sex: "M", uid: w).pluck(:uid)
        females = User.where(sex: "F", uid: w).pluck(:uid)
        ### calcoliamo quindi le percentuali di questi che hanno avuto inequivalenza, reazioni indesiderati ed inefficacia 
        
     
        
        @counts = Answer.select('answer').where(qid: 1, subid: 1, uid: w).group(:answer).count('answer')
        @counts.delete_if{|k, v| k.nil?}
        #binding.pry
        ### Percentuali degli effetti indesiderati divisi per genere
        @count_males = Answer.select('answer').where(qid: 1, subid: 1, uid: males).group(:answer).count('answer')
        @count_females = Answer.select('answer').where(qid: 1, subid: 1, uid: females).group(:answer).count('answer')
        
        @counts.keys.each do |k|
            if !(@count_males.include? k)
                @count_males[k] = 0
            end
            if !(@count_females.include? k)
                @count_females[k] = 0
            end
        end
         
        stacked_data = []
        all_keys = @counts.keys
        all_keys.each do |k|
            stacked_data << { :name => k, :data => [["M", @count_males[k]], ["F", @count_females[k]]] }
        end
        #binding.pry
        
        stacked_data
        #binding.pry
end

def get_indicator_description(n)
    indicator = "i"
    unless n < LOWER_INDICATOR || n > UPPER_INDICATOR
        indicator += n.to_s
    else
        raise ArgumentError, "invalid statistical indicator!"
    end
    
    #Here we collect the notes related to each answer
    notes = Answer.where("note <> ''").pluck(:note)
    #binding.pry
    collected_descriptions = []
     notes.each do |note|
        text = note.scan(/#{indicator}:\s*[^;]*;?/)[0]
        next if text.nil?
        parts = text.split(":")
        indicator_description = parts[1].strip.gsub(";", "").downcase
        collected_descriptions << indicator_description
    end    
    
    collected_descriptions
    
end 


def extract_info(keyword)
     pattern = keyword
     notes = Answer.where("note <> ''").pluck(:qid, :note)
     extracted_text = []
     qids = []
     notes.each do |note|
        if pattern == "reazioni indesiderate"
            text = note[1].scan(/#{pattern}[^;]*;?/)[0]

        else    
            text = note[1].scan(/.*#{pattern}[^;]*;/)[0]

        end
        qids << note[0] unless text.nil?
        extracted_text << text unless text.nil?
     end  
     return qids, extracted_text
end 
   
   
   def count_drug_effects(drug_name)
       drug = Drug.where('drug_name = ?', drug_name)
       all_effects = ["reazioni indesiderate", "inefficacia", "inequivalenza", "altro"]
       effects = drug.map{|d| d.effect}
       ### Now we obtain a dictionary in which each key is an effect
       ### and each value is the number of times that the effect was recorded
       
       effect_counts = Hash[effects.group_by{|e| e}.map{|k,v| [k, v.count]}]
       all_effects.each do |eff|
           if !effect_counts.keys.include? eff
               effect_counts[eff] = 0
           end
       end   
       ### here we initialize males and females hashes
       count_males = Hash[all_effects.map{|e| [e, 0]}]
       count_females = Hash[all_effects.map{|e| [e, 0]}]
       
       effect_sex = drug.map{|d| [d.effect, d.sex]}
       effect_sex.each do |es|
            if es[1] == "M"
                count_males[es[0]] += 1
            elsif es[1] == "F"
                count_females[es[0]] += 1
            end    
       end       
       stacked_data = []
       all_effects.each do |k|
           stacked_data << {:name => k, :data => [["M", count_males[k]], ["F", count_females[k]]] }
       end
       
       ##### Elapsed time ###
       elapsed_time = Drug.where("drug_name = ?", drug_name).pluck(:elapsed_time)
       elapsed_counts = Hash[elapsed_time.group_by{|e| e}.map{|k, v| [k, v.count]}]
       elapsed_counts.delete_if{|k, v| k.nil?}
       
     
     
       return effect_counts, stacked_data, elapsed_counts
   end
   
   def count_aggregate_drug_effects(drug_names)
       hash_array = []
       res = Hash.new(0)
       drug_names.each do |drug_name|
           h = count_drug_effects(drug_name)[0]
           hash_array.append(h)
       end
       #### Here we merge the hashing summing the values corresponding to the same key
       hash_array.each { |subhash| subhash.each { |prod, value| res[prod] += value } }
       res    
    end   
   
end
