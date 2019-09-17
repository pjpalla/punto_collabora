module AdvicesHelper
    
def session_cleaner
    advice_keys = session.keys.select{|key| key.to_s.match(/^advice*/)}
    advice_keys.each do |key|
        session.delete(key)
    end    
end

def get_choice(choice)
    res = "danger"
    if choice == "drugs"
        res = "primary"
    elsif choice == "health system"
        res = "warning"
    elsif choice == "shopping"
        res = "success"
    else    
        res = "danger"
    end
    res
end
    
    
    
end
