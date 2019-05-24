class UsersController < ApplicationController
  def index
    @users = User.all
    @locations = User.distinct.pluck(:place) +  ["cagliari", "carbonia", "nuoro", "sassari","sardegna"]
    
    all_users = User.count
    @males = User.where(sex: 'M').count
    @females = all_users - @males
    
    respond_to do |format|
      format.html
      format.js
    end  
    
  end
  
  # def users_by_age
  
  # end  
  
end
