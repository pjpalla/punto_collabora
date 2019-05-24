class Patient < ActiveRecord::Base
    has_one :profile
end
