class AdvicesController < ApplicationController
  include AdvicesHelper
  skip_before_action :authenticate_member!, except: [:advice_statistics, :index, :show]
  before_action :set_advice, only: [:show, :edit, :update, :destroy], except: [:intro]
  

  # GET /advices
  # GET /advices.json
  def index
     @advice_details = AdviceDetail.all.paginate(:page => params[:page], :per_page => 3)
     #@advices = Advice.all. paginate(:page => params[:page], :per_page => 3).order('id ASC')
  end
  
  def intro
    render "intro"
  end  

  # GET /advices/1
  # GET /advices/1.json
  def show
    @advice = Advice.find(params[:id])
    @advice_details = AdviceDetail.find_by_aid(@advice.id)
  end

  # GET /advices/new
  def new
    @selection = get_choice(params[:selection])
    session[:choice] = params[:selection]
    session[:color_selection] = @selection unless @selection.empty?
    logger.info "selection inside new: #{session[:color_selection]}"
    session[:advice_params] ||= {}
    @advice = Advice.new(session[:advice_params])
    @advice.current_step = session[:advice_step]
    #@advice = Advice.new
  end

  # GET /advices/1/edit
  def edit
  end

  # POST /advices
  # POST /advices.json
  def create
    session[:advice_params].deep_merge!(params[:advice]) if params[:advice]
    self.set_session
    
    logger.info "color_selection inside create: #{session[:color_selection]}"
    logger.info "session[:advice01] = #{session[:advice01]}"
    logger.info "choice inside create: #{session[:choice]}"
    
    @advice = Advice.new(session[:advice_params])
    @advice.current_step = session[:advice_step]

    if params[:back_button]
        @advice.previous_step
    elsif @advice.last_step?
        ActiveRecord::Base.transaction do
           @advice.save
           
           aid = @advice.id
           logger.debug "aid: #{aid}"
           advice_details = create_advice_details(aid, session)
           logger.debug "advice_details: #{advice_details.inspect}"
           advice_details.save 
           session_cleaner
        end
      
    else 
      @advice.next_step
    end
    session[:advice_step] = @advice.current_step    
    if @advice.new_record?
      # session.keys().each do |k|
      #   logger.info "#{k}: #{session[k]}"
      # end  
      render "new", color_selection: session[:color_selection]
      
    else
      session[:advice_step] = session[:advice_params] = nil
      flash[:success] = "Grazie della collaborazione!"
      redirect_to root_path(:step => "final_step")
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
    session[:color_selection] = params[:color_selection] if params[:color_selection]
    session[:choice] = params[:selection] if params[:selection]
    session[:advice01] = params[:advice01] if params[:advice01]
    session[:advice02_a] = params[:advice02_a] if params[:advice02_a] #Ospedale
    session[:advice02_b] = params[:advice02_b] if params[:advice02_b] #Farmacia
    session[:advice02_c] = params[:advice02_c] if params[:advice02_c] #Poliambulatorio
    session[:advice02_d] = params[:advice02_d] if params[:advice02_d] #Ambulatorio medico
    session[:advice03] = params[:advice03] if params[:advice03] #provincia selezionata
    session[:advice04_a] = params[:advice04_a] if params[:advice04_a] #Distribuzione presidi medici
    session[:advice04_b] = params[:advice04_b] if params[:advice04_b] #Sistemi di prenotazione
    session[:advice04_c] = params[:advice04_c] if params[:advice04_c] #Distribuzione di farmaci
    session[:advice04_d] = params[:advice04_d] if params[:advice04_d] #Campagne di vaccinazione  
    session[:advice04_e] = params[:advice04_e] if params[:advice04_e] #Altro 
    session[:advice05_a] = params[:advice05_a] if params[:advice05_a] #Distribuzione presidi medici
    session[:advice05_b] = params[:advice05_b] if params[:advice05_b] #Sistemi di prenotazione
    session[:advice05_c] = params[:advice05_c] if params[:advice05_c] #Distribuzione di farmaci
    session[:advice05_d] = params[:advice05_d] if params[:advice05_d] # Farmaci Inequivalenza
    session[:advice05_e] = params[:advice05_e] if params[:advice05_e] # Farmaci inefficacia
    session[:keyword] = params[:keyword] if params[:keyword]
  end
  
  
  def advice_statistics
    @advice_details = AdviceDetail.all
    ### Advice Statics ####
    ### Ambito - farmaci, sistema sanitario, farmaci acquistati su internet
    @choice_alternatives = AdviceDetail.all.uniq.pluck(:choice)
    @choices = AdviceDetail.all.group(:choice).count(:choice)
    @choices = change_key_case(@choices)
    # choices = {}
    # @choices.map{|k, v| choices[k.capitalize] = v}
    # @choices = choices
    ### Tipolagia di segnalazione
    @typologies = AdviceDetail.all.group(:typology).count(:typology)
    @typologies = change_key_case(@typologies)
    ## Strutture segnalate ##
    ### businsess logic moved to the view
    # @places = AdviceDetail.all.pluck(:place)
    # @places = count_elements(@places)
    # @places = change_key_case(@places)
    #@places_by_province = get_place_by_province()
    ### Oggetto Segnalazioni ###
    # @topics = count_elements(AdviceDetail.all.pluck(:topic))
    # @topics = change_key_case(@topics)
    ### Problematiche ###
    # problems = AdviceDetail.where(typology: "problema").pluck(:description)
    # problems = count_elements(problems)
    # @problems = change_key_case(problems)
    
    ## Suggerimenti ###
    # suggestions = AdviceDetail.where(typology: "esigenza/suggerimento").pluck(:description)
    # suggestions = count_elements(suggestions)
    # @suggestions = change_key_case(suggestions)
    occurrences1 = AdviceDetail.where(:choice => "farmaci").group(:keyword).count
    @chart1 = generate_bubble(occurrences1)
    
    occurrences2 = AdviceDetail.where(:choice => "farmaci acquistati su internet").group(:keyword).count
    @chart2 = generate_bubble(occurrences2)
    
    occurrences3 = AdviceDetail.where(:choice => "sistema sanitario").group(:keyword).count
    @chart3 = generate_bubble(occurrences3)
    
  
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
    #redirect_to :controller => "pages", :action => "home" 
    redirect_to root_path
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
