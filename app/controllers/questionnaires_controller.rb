class QuestionnairesController < ApplicationController
  before_action :set_questionnaire, only: [:solve,:show, :edit, :update, :destroy]
  before_action :set_course, only: []
  before_action :set_member, only: []
  before_action :set_lesson, only: []

  # GET /questionnaires
  # GET /questionnaires.json
  def index
    @questionnaires = Questionnaire.all
  end

  # GET /questionnaires/1
  # GET /questionnaires/1.json
  def show
  end
  
  def solve
    if !params[:answer].nil?
      @answer = params[:answer]
    else
      @answer = ""
    end
    @correct = @questionnaire.answer
    respond_to do |format|
          format.js {}
          format.json {}
    end  
  end

  # GET /questionnaires/new
  def new
    @questionnaire = Questionnaire.new
  end

  # GET /questionnaires/1/edit
  def edit
  end

  # POST /questionnaires
  # POST /questionnaires.json
  def create     
    @questionnaire = Questionnaire.new(questionnaire_params)
    @questionnaire.user=current_user
     respond_to do |format|
      if @questionnaire.save
        format.html { redirect_to user_tests_path, notice: 'Questionnaire was successfully created.' }
        format.json { render action: 'index', status: :created, location: user_tests_path}
      else
        format.html { render action: 'new' }
        format.json { render json: @questionnaire.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /questionnaires/1
  # PATCH/PUT /questionnaires/1.json
  def update
    respond_to do |format|
      if @questionnaire.update(questionnaire_params)
        format.html { redirect_to user_tests_path, notice: 'Questionnaire was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @questionnaire.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /questionnaires/1
  # DELETE /questionnaires/1.json
  def destroy
    @questionnaire.destroy
    respond_to do |format|
      format.html { redirect_to user_tests_path }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_questionnaire
      if !params[:id].nil?
        @questionnaire = Test.find(params[:id])
      elsif !params[:questionnaire_id].nil?
        @questionnaire = Test.find(params[:questionnaire_id])
      else
        @questionnaire = Test.find(params[:test_id])
      end
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def questionnaire_params
      params.require(:questionnaire).permit(:name,:question, :answer)
    end
end
