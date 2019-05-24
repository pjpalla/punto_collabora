

class QuestionsController < ApplicationController
    include QuestionsHelper       
    
    
  def index

    @questions = Question.all
    qids = @questions.map{|q| q.qid}
    @num_of_questions = qids.uniq.length
    #binding.pry
  end
  
  def show
     @subq_mapping = {1 => "A", 2 => "B", 3 => "C", 4 => "D"} 
     @first_question = 1
     @last_question = 18
     question_idx = [2, 3, 4, 5,  6, 7]
     @subquestion_idx = [4, 5, 7, 11]
     qone = get_reference_question(params[:id].to_i)
     #binding.pry
     #logger.warn "qone: #{qone}"
     

     #parent_one = 1
     
     @question = Question.where("qid = ? AND subid = ?", params[:id], 0)[0]
     @question_number = Question.where(subid: 0).length
     opt = QuestionOption.where("qid = ? AND subid = ?", params[:id], 0)
     @options = opt.map{|o| o.odescription}
     
    # counter = []
     total = []
     
     Answer.where("qid = ? and  subid = ?", params[:id], 0).each do |a|
         if question_idx.include? a.qid
             #parent_ans = Answer.where(qid: parent_one, subid: 0, uid: a.uid)[0].answer
             parent_ans = qone[a.uid]
              #logger.debug "parent answer (controller): #{parent_ans}"
                if parent_ans =~ /no\s*/i || parent_ans.nil?
                     #logger.debug "inside if"
                     next
                end
                #binding.pry
         end
          total << a.answer

    end
      
       #logger.debug "Total: #{total}"
       @counts = Hash.new 0
       @count_drugs = Hash.new 0
       @count_categories = Hash.new 0
       #resp_vect = []

       logger.debug "total length: #{total.length}"
       total.each do |resp|
           resp = resp.downcase unless resp.nil?
           resp.nil? ? resp = "nessuna risposta" : resp.strip!
           #binding.pry
           #logger.debug("resp: #{resp}")
           if resp =~ /^farmaco/
              #logger.warn "resp: #{resp}"
                resp_vect = resp.split(",").map{|w| w.downcase}
                #logger.debug "Resp vect: #{resp_vect}"
                drug = resp_vect[0].gsub("farmaco: ", "").strip
                #logger.info "Drug: #{drug}"
                category = resp_vect[1].gsub("categoria: ", "").strip
                #logger.info "Category: #{category}"
              unless drug.nil? || drug == ""
                    drug = sanitize_drug_name(drug)
                    @count_drugs[drug] += 1
              end   
              unless category.nil? || category == ""
                    @count_categories[category] += 1
              end
           end
           
           @counts[resp] += 1
        end
    #binding.pry 
    logger.debug "Counts: #{@counts}"
     #binding.pry
     #binding.pry
     @counts.slice!("sì", "no") if [5, 6, 7].include? @question.qid
     
     
     @count_drugs = filter_counts(@count_drugs, 1)
     ###here we sort by value in descending order
     @count_drugs = (@count_drugs.sort_by{|drug, count| -count}).to_h
     
     @count_categories = filter_counts(@count_categories, 1)
     @count_categories = (@count_categories.sort_by{|category, count| -count}).to_h
     #binding.pry
     #logger.debug "count_categories: #{@count_categories}"
     @subquestions = Question.where("qid = ? AND subid <> 0", params[:id])
     @suboptions = QuestionOption.where("qid = ? AND subid <> 0", params[:id])
     
     
  end
  
    def edit
        id = params[:id]
        @question = Question.where(qid: id)[0]
    end    
  
    def notes
      @answers = Answer.all.order(:qid)

    end      

  
  
  
  private
  def get_reference_question(qid)
        question_id = case qid
        when 1..7 then 1
        when 9..10 then 9
        end    
        #logger.warn "question_id: #{question_id}"
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
  
  
  
  
  
  
  
  
  
end
