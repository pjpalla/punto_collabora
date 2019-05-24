require '../../config/environment'


Answer.where("qid = ? and  subid = ?", 3, 0).each do |a|
    if a.answer.nil? || a.answer.empty?
        next
    end    
    answ = a.answer    
    if answ =~ /^Farmaco: omeprazolo generico/ 
        puts "old answ: #{answ}"
        new_answ = answ.gsub(" generico", "")
        puts "new answ: #{new_answ}"
        a.answer = new_answ
        a.save!        
    end
end