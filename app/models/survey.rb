class Survey < ActiveRecord::Base
    attr_writer :current_step
    
    
    def current_step
        @current_step || steps.first
    end    

    def steps
        %w[intro q1 q2 q3 q4 q5 q6 q7 q8 q9 q10 q11 q12 q13 q14 q15 q16 q17 q18 confirmation]
    end
    
    def next_step
        self.current_step = steps[steps.index(current_step) + 1]
    end
    
    def previous_step
        self.current_step = steps[steps.index(current_step) - 1]
    end
    
    def first_step?
        current_step == steps.first
    end    
        
    def last_step?
        current_step == steps.last
    end
    
    def step_index
        steps.index(current_step)
    end    
    
end
