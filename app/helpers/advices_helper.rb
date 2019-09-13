module AdvicesHelper
    
        def session_cleaner
        
        advice_keys = session.keys.select{|key| key.to_s.match(/^advice*/)}
        advice_keys.each do |key|
            session.delete(key)
        end    
    end    

    
    
    
end
