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


def extract_choice(choice)
    if choice == "drugs"
        res = "farmaci"
    elsif choice == "health system"
        res = "sistema sanitario"
    elsif choice == "shopping"
        res = "farmaci acquistati su internet"
    else
        res = "scelta non effettuata"
    end
    res
end    

def create_advice_details(advice_id, session)
    advice_details = AdviceDetail.new
    places = []
    topics = []
    descriptions = []
    aid = advice_id
    ### building of the advice details object ##
    advice_details.aid = aid
    
    session.keys().each do |k|
        if k == "choice"
            advice_details.choice = extract_choice(session[k])
        end
        
        if k == "advice01"
            advice_details.typology = session[k].downcase
        end
        if k == "advice02"
            advice_details.province = session[k]
        end
        if k  =~ /advice03_/
           places.append(session[k].downcase)
        end
        if k  =~ /advice04_/
            topics.append(session[k].downcase)
        end
        if k  =~ /advice05_/
            descriptions.append(session[k].downcase)
        end
        if k == "keyword"
            advice_details.keyword = session[k].downcase
        end            
            
    end
    places = places.reject { |e| e.to_s.empty? }
    topics = topics.reject {|e| e.to_s.empty?}
    descriptions = descriptions.reject {|e| e.to_s.empty?}
    advice_details.place = places.join(", ")
    advice_details.topic = topics.join(", ")
    advice_details.description = descriptions.join(", ")
    
    return advice_details

end

def change_key_case(dictionary)
    new_dict =  {}
    dictionary.map do |k, v|
        unless k.nil?
            new_dict[k.capitalize] = v
        end
    end    
    return new_dict
end

def count_elements(original_list)
    elements = []
    counts = Hash.new(0)
    original_list.each do |p|
        elements.append(p.split(", "))
        #elements.append(p)
    end
    pp = elements.flatten()
    
    pp.each{|e| counts[e] += 1}
    counts
    counts = change_key_case(counts)
    counts
end

def get_places_by_choice(choice)
    places = AdviceDetail.where(:choice => choice).pluck(:place)
    places = count_elements(places)
    places = change_key_case(places)
    places
end    


def get_place_by_province(choice)
    provinces = AdviceDetail.where(:choice => choice).distinct.pluck(:province)
    stacked_data = []
    provinces.each do |p|
       place_list = AdviceDetail.where(province: p, choice: choice).pluck(:place)
       places = count_elements(place_list)
       d = {:name => p, :data => places.map{|k, v| [k.capitalize, v]}}
       stacked_data.append(d)
    end 
    stacked_data
end

### the method provides the reportings (topics) and the related problems or advices. It correlates a particular reporting to the different problems or advices (description)
def get_topic_by_description(typology)
    reportings = AdviceDetail.where(:typology => typology).distinct.pluck(:topic)
    
    stacked_data = []
    reportings.each do |r|
        description_list = AdviceDetail.where(topic: r, typology: typology).pluck(:description)
        logger.info "Description List: #{description_list}"
        descriptions = count_elements(description_list)
        logger.info "*** descriptions: #{descriptions}"
        d = {:name => r, :data => descriptions.map{|k,v| [k.capitalize, v]}}
        stacked_data.append(d)
    end
    stacked_data
end    
        
    


def create_bubble_series(keyword_occurences)
    bubble_series = []
    xmax = keyword_occurences.keys.length 
    ymax = keyword_occurences.values.max
    logger.info "ymax: #{ymax}"
    
    tot = keyword_occurences.values.sum
    bubble_series = keyword_occurences.map do |k,v|
        
        percentage = 100*(v.to_f/tot).round(3)
        {x: rand(xmax + 5), y: v, z: v, keyword: k, percentuale: percentage}

    end
    #binding.pry
    bubble_series
    
end    

def generate_bubble(occurrences)
   #bubble_series = [{x: 1, y: 2, z: 3}, {x: 4, y: 5, z: 6}]
   bubble_series = create_bubble_series(occurrences)
   logger.info "bubble_series: #{bubble_series}"
   mychart = LazyHighCharts::HighChart.new('bubble') do |f|
          f.title(text: 'Distribuzione delle keyword utilizzate')            
          f.chart(type: 'bubble', zoomType: 'xy', plotBorderWidth: 1) 
          f.xAxis [title: {text: 'Keywords'}]
          f.yAxis [title: {text: 'Occorrenze' }]
          f.tooltip({
                useHTML: true,
                headerFormat: '<table>',
                pointFormat: '<tr><th colspan="2"><h3>{point.country}</h3></th></tr>' +
                    '<tr><th>Keyword:</th><td>{point.keyword}</td></tr>' +
                    '<tr><th>Occorrenze:</th><td>{point.z}</td></tr>' +
                    '<tr><th>Percentuale:</th><td>{point.percentuale}%</td></tr>',
                footerFormat: '</table>',
                followPointer: true
          })
          f.series(
            data: bubble_series,
            marker: {
              fillColor: {
                radialGradient: { cx: 0.4, cy: 0.3, r: 0.7 },
                stops: [ [0, 'rgba(255,255,255,0.5)'], [1, 'rgba(69,114,167,0.5)'] ]
             }
           }
         )
    end
    mychart
end    
    
end    

