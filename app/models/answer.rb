class Answer < ActiveRecord::Base
    belongs_to :questions
    has_one :user
end
