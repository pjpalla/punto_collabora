class MembersController < Devise::RegistrationsController
   skip_before_action :require_no_authentication
   before_action :authenticate_member!
   prepend_before_action :authenticate_scope!, only: [ :new, :create, :edit, :update, :destroy]
   prepend_before_action :set_minimum_password_length, only: [:new, :edit]
   
   def index
     @members = Member.all
   end
   
   #binding.pry
   def new
      super       
   end
   
   def create
      super
   end
   
   def edit
      super
   end
   
   def update
      super
   end   

end    