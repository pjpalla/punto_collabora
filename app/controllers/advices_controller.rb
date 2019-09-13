class AdvicesController < ApplicationController
  include AdvicesHelper
  skip_before_action :authenticate_member!
  before_action :set_advice, only: [:show, :edit, :update, :destroy], except: [:intro]
  

  # GET /advices
  # GET /advices.json
  def index
    @advices = Advice.all
  end
  
  def intro
    render "intro"
  end  

  # GET /advices/1
  # GET /advices/1.json
  def show
  end

  # GET /advices/new
  def new
    session[:advice_params] ||= {}
    @advice = Advice.new(session[:advice_params])
    @advice.current_step = session[:advice_step]
    @advice = Advice.new
  end

  # GET /advices/1/edit
  def edit
  end

  # POST /advices
  # POST /advices.json
  def create
    session[:advice_params].deep_merge!(params[:advice]) if params[:advice]
    self.set_session
    @advice = Advice.new(session[:advice_params])
    @advice.current_step = session[:advice_step]
    if params[:back_button]
        @advice.previous_step
    elsif @advice.last_step?
      session_cleaner
      
    else 
      @advice.next_step
    end
    session[:advice_step] = @advice.current_step    
    if @advice.new_record?
      render "new"
    else
      session[:advice_step] = session[:advice_params] = nil
      flash[:notice] = "Advice correttamente inserito!"
      redirect_to advice_path
      #redirect_to @survey
    end  

    #@advice = Advice.new(advice_params)

    # respond_to do |format|
    #   if @advice.save
    #     format.html { redirect_to @advice, notice: 'Advice was successfully created.' }
    #     format.json { render :show, status: :created, location: @advice }
    #   else
    #     format.html { render :new }
    #     format.json { render json: @advice.errors, status: :unprocessable_entity }
    #   end
    # end
  end
  
  def set_session
  
  end  
  

  # PATCH/PUT /advices/1
  # PATCH/PUT /advices/1.json
  def update
    respond_to do |format|
      if @advice.update(advice_params)
        format.html { redirect_to @advice, notice: 'Advice was successfully updated.' }
        format.json { render :show, status: :ok, location: @advice }
      else
        format.html { render :edit }
        format.json { render json: @advice.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /advices/1
  # DELETE /advices/1.json
  def destroy
    @advice.destroy
    respond_to do |format|
      format.html { redirect_to advices_url, notice: 'Advice was successfully destroyed.' }
      format.json { head :no_content }
    end
  end
  
  
  def leave
    session_cleaner
    redirect_to :controller => "pages", :action => "home" 
  end  


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_advice
      @advice = Advice.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def advice_params
      params.require(:advice).permit(:uid)
    end
end
