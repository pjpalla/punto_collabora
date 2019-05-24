class SurveysController < ApplicationController
  include SurveysHelper
  before_action :set_survey, only: [:show, :edit, :update, :destroy]
  
  
  

  # GET /surveys
  # GET /surveys.json
  def index
    @surveys = Survey.paginate(:page => params[:page], :per_page => 3).order('id ASC')
    #@surveys = Survey.all
  end

  # GET /surveys/1
  # GET /surveys/1.json
  def show
    
  end

  # GET /surveys/new
  def new
    session[:survey_params] ||= {}
    @survey = Survey.new(session[:survey_params])
    @survey.current_step = session[:survey_step]
  end

  # GET /surveys/1/edit
  def edit
  end

  # POST /surveys
  # POST /surveys.json
  def create
    @questions = Question.all
    session[:survey_params].deep_merge!(params[:survey]) if params[:survey]
    self.set_session
    @survey = Survey.new(session[:survey_params])
    @survey.current_step = session[:survey_step]
    if params[:back_button]
        @survey.previous_step
    elsif @survey.last_step?
     ####User creation##
        uid, sex, age, card = create_user
        #uid, sex, age, card = [80000, "M", "30/40", "P00001"]
        # uid = 9999
        @survey.uid = uid
        @survey.card = card
        answers = session_processor(uid)
        drug = create_drug(sex, age)
        indicator_obj = count_indicators(uid, card)
  #### temporary commented #####
        ### These actions must occur as one atomic transaction
        ActiveRecord::Base.transaction do
          answers.each{|a| a.save}
          drug.save unless drug.blank?
          indicator_obj.save unless indicator_obj.blank?
          logger.warn "answers: #{answers}"
          logger.warn "drug: #{drug.attributes}" unless drug.blank?
          logger.warn "indicator: #{indicator_obj.attributes}" unless indicator_obj.blank?
          @survey.save
          session_cleaner
        end
    else 
      @survey.next_step
    end
    session[:survey_step] = @survey.current_step
    if @survey.new_record?
      render "new"
    else
      session[:survey_step] = session[:survey_params] = nil
      flash[:notice] = "Questionario correttamente inserito!"
      redirect_to surveys_path
      #redirect_to @survey
    end  
  end
  
    def set_session
      session[:card_number] = params[:card_number] if params[:card_number]
      session[:collection_point] = params[:collection_point] if params[:collection_point] 
      session[:sex] = params[:sex] if params[:sex]
      session[:eta] = params[:eta] if params[:eta]
      #q1
      session[:answer01_0] = params[:answer01_0] if params[:answer01_0]
      session[:answer01_1] = params[:answer01_1] if params[:answer01_1]
      session[:answer01_note] = params[:answer01_note] if params[:answer01_note]
      #q2
      session[:answer02_0] = params[:answer02_0] if params[:answer02_0]
      session[:answer02_note] = params[:answer02_note] if params[:answer02_note]
      #q3
      session[:answer03_drug_name_0] = params[:answer03_drug_name] if params[:answer03_drug_name]
      session[:answer03_drug_category_0] = params[:answer03_drug_category] if params[:answer03_drug_category]
      session[:answer03_dosage_0] = params[:answer03_dosage] if params[:answer03_dosage]
      session[:answer03_1] = params[:answer03_1] if params[:answer03_1]
      session[:answer03_note] = params[:answer03_note] if params[:answer03_note]
      #q4
      session[:answer04_drug_name_1] = params[:answer04_drug_name] if params[:answer04_drug_name]
      session[:answer04_drug_category_1] = params[:answer04_drug_category] if params[:answer04_drug_category]
      session[:answer04_dosage_1] = params[:answer04_dosage] if params[:answer04_dosage]
      session[:answer04_0] = params[:answer04_0] if params[:answer04_0]
      session[:answer04_note] = params[:answer04_note] if params[:answer04_note] 
      #q5
      session[:answer05_0] = params[:answer05_0] if params[:answer05_0]
      session[:answer05_drug_name_1] = params[:answer05_drug_name] if params[:answer05_drug_name]
      session[:answer05_drug_category_1] = params[:answer05_drug_category] if params[:answer05_drug_category]
      session[:answer05_dosage_1] = params[:answer05_dosage] if params[:answer05_dosage]
      session[:answer05_note] = params[:answer05_note] if params[:answer05_note]      
      #q6
      session[:answer06_0] = params[:answer06_0] if params[:answer06_0]
      session[:answer06_1] = params[:answer06_1] if params[:answer06_1]
      session[:answer06_note] = params[:answer06_note] if params[:answer06_note]
      #q7
      session[:answer07_0] = params[:answer07_0] if params[:answer07_0]
      session[:answer07_drug_name_1] = params[:answer07_drug_name] if params[:answer07_drug_name]
      session[:answer07_drug_category_1] = params[:answer07_drug_category] if params[:answer07_drug_category]
      session[:answer07_dosage_1] = params[:answer07_dosage] if params[:answer07_dosage]
      session[:answer07_note] = params[:answer07_note] if params[:answer07_note]
      #q8
      session[:answer08_0] = params[:answer08_0] if params[:answer08_0]
      session[:answer08_1] = params[:answer08_1] if params[:answer08_1]
      session[:answer08_note] = params[:answer08_note] if params[:answer08_note]
      #q9
      session[:answer09_0] = params[:answer09_0] if params[:answer09_0]
      session[:answer09_note] = params[:answer09_note] if params[:answer09_note]
      #q10
      session[:answer10_0] = params[:answer10_0] if params[:answer10_0]
      session[:answer10_note] = params[:answer10_note] if params[:answer10_note]
      #q11
      session[:answer11_0] = params[:answer11_0] if params[:answer11_0]
      session[:answer11_drug_name_1] = params[:answer11_drug_name] if params[:answer11_drug_name]
      session[:answer11_drug_category_1] = params[:answer11_drug_category] if params[:answer11_drug_category]
      session[:answer11_dosage_1] = params[:answer11_dosage] if params[:answer11_dosage]
      session[:answer11_2] = params[:answer11_2] if params[:answer11_2]
      session[:answer11_note] = params[:answer11_note] if params[:answer11_note]
      #q12
      session[:answer12_0] = params[:answer12_0] if params[:answer12_0]
      session[:answer12_note] = params[:answer12_note] if params[:answer12_note]
      #q13
      session[:answer13_0] = params[:answer13_0] if params[:answer13_0]
      session[:answer13_note] = params[:answer13_note] if params[:answer13_note]
      #q14
      session[:answer14_0] = params[:answer14_0] if params[:answer14_0]
      session[:answer14_note] = params[:answer14_note] if params[:answer14_note]      
      #q15
      session[:answer15_0] = params[:answer15_0] if params[:answer15_0]
      session[:answer15_note] = params[:answer15_note] if params[:answer15_note]
      #q16
      session[:answer16_0] = params[:answer16_0] if params[:answer16_0]
      session[:answer16_note] = params[:answer16_note] if params[:answer16_note]      
      #q17
      session[:answer17_0] = params[:answer17_0] if params[:answer17_0]
      session[:answer17_note] = params[:answer17_note] if params[:answer17_note]      
      #q18
      session[:answer18_0] = params[:answer18_0] if params[:answer18_0]
      session[:answer18_note] = params[:answer18_note] if params[:answer18_note]      
    end

    # respond_to do |format|
    #   if @survey.save
    #     format.html { redirect_to @survey, notice: 'Survey was successfully created.' }
    #     format.json { render :show, status: :created, location: @survey }
    #   else
    #     format.html { render :new }
    #     format.json { render json: @survey.errors, status: :unprocessable_entity }
    #   end
    # end


  # PATCH/PUT /surveys/1
  # PATCH/PUT /surveys/1.json
  def update
    respond_to do |format|
      if @survey.update(survey_params)
        format.html { redirect_to @survey, notice: 'Survey was successfully updated.' }
        format.json { render :show, status: :ok, location: @survey }
      else
        format.html { render :edit }
        format.json { render json: @survey.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /surveys/1
  # DELETE /surveys/1.json
  def destroy
    @survey.destroy
    respond_to do |format|
      format.html { redirect_to surveys_url, notice: 'Survey was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_survey
      @survey = Survey.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def survey_params
      params.require(:survey).permit(:uid, :card)
    end
end
