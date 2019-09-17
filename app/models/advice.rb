class Advice < ActiveRecord::Base
    attr_writer :current_step
    
    
    def current_step
        @current_step || steps.first
    end
    
    def current_step_idx(step)
        steps.index(step) + 1
    end

    def steps
        %w[ a1 a2 a3 a4 a5 confirmation]
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
