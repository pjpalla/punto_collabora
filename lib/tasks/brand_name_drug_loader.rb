require '../../config/environment'

drug_list = []

Answer.where("qid = ? and  subid = ?", 3, 0).each do |a|
    if a.answer.nil? || a.answer.empty?
        next
    else
        answ = a.answer.downcase
    end    
    if answ =~ /^farmaco/ && !answ.empty? 
        answ_vect = answ.split(",").map{|w| w.downcase}
        drug = answ_vect[0].gsub("farmaco:", "").strip
        category = answ_vect[1].gsub("categoria:", "").strip unless answ_vect[1].nil?
        dosage = answ_vect[2].gsub("dosaggio:", "").strip unless answ_vect[2].nil?
        puts dosage unless dosage.empty?
        if drug =~ /^ketoprofene|chetoprofene/
            #puts "found drug: #{drug}"
            drug = "ketoprofene"
            #puts "converted: #{drug}"
        elsif drug =~ /^enn?$/
           # puts "found drug: #{drug}"
            drug = "enn"
            #puts "converted: #{drug}"
        elsif drug =~ /cetamol/
            #puts "found drug: #{drug}"
            drug = "paracetamolo"
            #puts "converted drug: #{drug}"
        elsif drug =~ /^loperamide/
            #puts "found drug: #{drug}"
            drug = "loperamide"
            #puts "converted drug: #{drug}"    
        end
        user_id = a.uid
        side_effect = Answer.where("qid = ? and  subid = ? and uid = ?", 1, 1, user_id).pluck(:answer)[0]
        elapsed_time = Answer.where("qid = ? and subid = ? and uid = ?", 2, 0, user_id).pluck(:answer)[0]
        sex, age_range = User.where("uid = ?", user_id).pluck(:sex, :age)[0]
        
        [side_effect, sex, age_range, elapsed_time].map{|x| x.strip! unless x.nil?}
 
        
        # puts "** Drug: #{drug} ***"
        # puts "** side effects: #{side_effect} ***"
        # puts "** elapsed_time: #{elapsed_time} ***"
        # puts "** sex: #{sex} ***"
        # puts "** age_range: #{age_range} ***"
        
        #Drug.create(drug_name: drug, category: category, dosage: dosage, effect: side_effect, sex: sex, 
        #age_range: age_range, elapsed_time: elapsed_time, )
        
        drug_list << drug unless drug.empty?
        #puts(drug) unless drug.empty?
    end
end 

puts "drug list length: #{drug_list.length}"
#puts drug_list
#aggregated_drug_list drug_list.map do |d|
    

