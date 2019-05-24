module UsersHelper
    
    def users_by_sex
        
        users = @users.group(:sex).count
        users = users.delete_if{|k,v| k.nil?}
        logger.debug "Users: #{users}"
      
        pie_chart users, library: {title: "Ripartizione per sesso", pieHole: 0.4}
        # pie_chart users, height: '400px', library: {
        #   title: {text: 'Users by sex', x: -20},
        #   yAxis: {
        #      allowDecimals: false,
        #      title: {
        #          text: 'Sex count'
        #      }
        #   },
        #   xAxis: {
        #      allowDecimals: false, 
        #      title: {
        #          text: 'Age'
        #      }
        #   }
        # }
    end
    
    
    
    
    def users_by_age
        
        users = User.all
        u = users
        users = users.each{|u| u.age.strip! unless u.age.nil?}
        ages = users.map{|u| u.age}.compact
        ### here we count the users for each age
        h = Hash.new(0)
        ages.each{|a| h[a] += 1}
        users = h
        #binding.pry
        #users = users.group(:age).count
        #binding.pry
        
        #Here we remove spaces from the beginning and the end of each key
        #and we build a new hash
        #users = Hash[users.map{|k,v| [k.strip, v] unless k.nil?}]
        
        #Then we sort the keys of the users hash
        users = users.sort.to_h
        bar_chart users, library: {title: "Ripartizione per fasce d'età", colors: ["green"]}   
        
        # bar_chart users, height: '500px', library: {
        #   title: {text: 'Users by age', x: -20},
        #   yAxis: {
        #      allowDecimals: false,
        #      title: {
        #          text: 'Ages count'
        #      }
        #   },
        #   xAxis: {
        #      allowDecimals: false, 
        #      title: {
        #          text: 'Age'
        #      }
        #   }
        # }
    end
    
    
    def users_by_place
        users = User.group(:collection_point).count
        counters = Array.new(5,0)
        users.each do |k, v|
                if k =~ /sardara(.)*/i
                    counters[0] += v
     
                elsif k =~ /san gavino(.)*/i
                    counters[1] += v
                elsif k =~ /sanluri(.)*/i
                    counters[2] += v
                elsif k =~ /villacidro(.)*/i
                    counters[3] += v
                elsif k =~ /guspini(.)*/i
                    counters[4] += v
                elsif  k =~ /serrenti(.)*/i
                    counters[0] += v
                elsif  k =~ /samassi(.)*/i
                    counters[0] += v
                elsif  k =~ /serramanna(.)*/i
                    counters[0] += v                    
                end    
            end
        user_locations = {"Ambulatori Medici, Farmacie" => counters[0], "Presidi Sanitari S.Gavino" => counters[1], "Presidi Sanitari Sanluri" => counters[2],
                            "Presidi Sanitari Villacidro" => counters[3], "Presidi Sanitari Guspini" => counters[4]}
                            
        user_locations = user_locations.sort_by{|name, value| -value}.to_h                    
        line_chart user_locations, xtitle: "Centri di Raccolta", height: "450px", width: "1400"                    
        
    end
    
#     def users_by_place
#         users = User.group(:collection_point).count
#         #Here we strip blank spaces from each key
#  #       users = Hash[users.map{|k,v| [k.downcase.strip, v] unless k.nil? || k == ""}]
        
#         counters = Array.new(8,0)
#         #### temporary solution #####
#             users.each do |k, v|
#                 if k =~ /sardara(.)*/i
#                     counters[0] += v
     
#                 elsif k =~ /san gavino(.)*/i
#                     counters[1] += v
#                 elsif k =~ /sanluri(.)*/i
#                     counters[2] += v
#                 elsif k =~ /villacidro(.)*/i
#                     counters[3] += v
#                 elsif k =~ /guspini(.)*/i
#                     counters[4] += v
#                 elsif  k =~ /serrenti(.)*/i
#                     counters[5] += v
#                 elsif  k =~ /samassi(.)*/i
#                     counters[6] += v
#                 elsif  k =~ /serramanna(.)*/i
#                     counters[7] += v                    
#                 end    
#             end
        
#           user_locations = {"sardara" => counters[0], "san gavino" => counters[1], "sanluri" => counters[2],
#                             "villacidro" => counters[3], "guspini" => counters[4], "serrenti" => counters[5], 
#                             "samassi" => counters[6], "serramanna" => counters[7]}
           
#           line_chart user_locations 
#         #   binding.pry
#         end    
        
 
    
 
    
    
end
