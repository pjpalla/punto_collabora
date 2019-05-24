class Option < ActiveRecord::Base
    belongs_to :question, :class_name => "Question", :foreign_key => 'qid'
end
