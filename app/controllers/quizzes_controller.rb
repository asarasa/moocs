class QuizzesController < ApplicationController
  before_action :set_quiz, only: [:single,:multi,:show, :edit, :update, :destroy]
 

  # GET /quizzes
  # GET /quizzes.json
  def index
    @quizzes = Quizzes.All
  end

  # GET /quizzes/1
  # GET /quizzes/1.json
  def show
  end
  
  def add_answers
    @quiz = Test.find(params[:quiz_id])
  end

  def see_answers    
     @quiz = @resource.tests.find(params[:quiz_id])
     @quiz.users.push(current_user.id)
     @quiz.update()
  end
  
  def single
    if !params[:answer].nil?
      @correct= @quiz.answers.where(valid: true).to_a[0].id      
      @answer = params[:answer]
      respond_to do |format|
          format.js {}
          format.json {}
      end
      end  
    end
  
  def multi
     if params[:answers].nil?
       @answers=Array.new
     else 
       @answers=params[:answers]
     end  
    @correct = Array.new
    @quiz.answers.where(valid: true).to_a.each do |cor|
      @correct << cor.id.to_s
    end  
    respond_to do |format|
            format.js {}
            format.json {}
       end
  end

  # GET /quizzes/new
  def new
    if !params[:course_id].nil?
      @course=params[:course_id]
      @lecture=params[:lecture_id]
    end
    @quiz = Quiz.new
  end

  # GET /quizzes/1/edit
  def edit
  end

  # POST /quizzes
  # POST /quizzes.json
  def create   
    if !params[:course_id].nil?
      @course=Course.find(params[:course_id])
      @lecture=@course.lectures.find(params[:lecture_id])
    end
    @quiz= Quiz.new(quiz_params)
    @quiz.user=current_user
    params[:array].each do |answer|
      @quiz.answers << Answer.new(answer: answer[1][:answer],valid: answer[1][:valid])
    end
    respond_to do |format|
       if @quiz.save
         if @course.nil?
           format.html { redirect_to user_tests_path, notice: 'Quiz was successfully created, update the answers.' }
         else
           format.html { redirect_to testinlecture_create_path(@course,@lecture,:id => @quiz.id)}
         end
      else
         format.html { render action: 'new' }
      end
    end
  end

  # PATCH/PUT /quizzes/1
  # PATCH/PUT /quizzes/1.json
  def update
    @quiz.answers.clear
    params[:array].each do |answer|
      logger.debug answer[1][:answer]
      logger.debug answer[1][:valid]      
       @quiz.answers << Answer.new(answer: answer[1][:answer],valid: answer[1][:valid])
    end
    respond_to do |format|
      if @quiz.update(quiz_params)
        format.html { redirect_to user_tests_path, notice: 'Quiz was successfully updated, update the answers.' }
      else
        format.html { render action: 'edit' }
      end
    end
  end

  # DELETE /quizzes/1
  # DELETE /quizzes/1.json
  def destroy
    @quiz.destroy
    respond_to do |format|
      format.html { redirect_to user_tests_path }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_quiz
      if !params[:id].nil?
        @quiz = Test.find(params[:id])
      elsif !params[:quiz_id].nil?
        @quiz = Test.find(params[:quiz_id])
      else
        @quiz = Test.find(params[:test_id])
      end
    end
  
    # Never trust parameters from the scary internet, only allow the white list through.
    def quiz_params
      params.require(:quiz).permit(:question, :name)
    end
  
    
end
