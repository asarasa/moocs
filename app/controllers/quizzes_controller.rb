class QuizzesController < ApplicationController
  before_action :set_quiz, only: [:show, :edit, :update, :destroy]
 

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
  
  def solve
     params.require(:quiz).permit(:answer)
     @quiz = @resource.tests.find(params[:quiz_id])
     @quizzes = @resource.tests
     list = Array.new  
     if @quiz.multianswer == true
       index=0  
       hash = params[:quiz][:answer]    
       hash.each do |a|    
          if (a[1][:results] == "1")
           list.push(index)
          end  
          index = index + 1
       end
     else
       result=params[:quiz][:results].to_i
       list.push(result)
     end  
    if (list == @quiz.results) 
      @quiz.users << current_user
      respond_to do |format|
        if @quiz.update()
          format.html { redirect_to resource_tests_path(@resource), notice: 'Quiz was successfully solved' }
        else
         
          format.html { render action: 'show', notice: 'Update Error' }
        end
      end    
    else 
      redirect_to resource_quiz_path(@resource, @quiz), notice: 'Quiz was not successfully solved'
    end    
  end

  
  def new_answers
    @quiz = Test.find(params[:quiz_id])
    @quiz.answers = Array.new
    @quiz.results = Array.new 
    index=0
    hash = params[:quiz][:answer]
    if @quiz.multianswer == true
      hash.each do |a|
        @quiz.answers.push(a[1][:answers])
        if (a[1][:results] == "1")
          @quiz.results.push(index)
        end  
        index = index + 1
      end
    else 
      hash.each do |a|
        @quiz.answers.push(a[1][:answers])
      end 
      @quiz.results.push(params[:quiz][:results].to_i)      
    end
    respond_to do |format|
      if @quiz.update()
        format.html { redirect_to user_tests_path, notice: 'Quiz was successfully updated, update the answers.' }
      else
        format.html { render action: 'edit' }
      end
    end
  end

  # GET /quizzes/new
  def new
    @quiz = Quiz.new
  end

  # GET /quizzes/1/edit
  def edit
  end

  # POST /quizzes
  # POST /quizzes.json
  def create
    @quiz = Quiz.new(quiz_params)
    @quiz.answers = Array.new
    @quiz.results = Array.new 
    @quiz.user = current_user
    respond_to do |format|
      if @quiz.save
        format.html { redirect_to quiz_add_answers_path(@quiz), notice: 'Quiz was successfully, enter the answers.' }
      else
        format.html { render action: 'new' }
      end
    end
  end

  # PATCH/PUT /quizzes/1
  # PATCH/PUT /quizzes/1.json
  def update
    respond_to do |format|
      if @quiz.update(quiz_params)
        format.html { redirect_to resource_quiz_add_answers_path(@resource,@quiz), notice: 'Quiz was successfully updated, update the answers.' }
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
      @quiz = Test.find(params[:id])
     
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def quiz_params
      params.require(:quiz).permit(:question, :multianswer,:numanswers,:answer,:name)
    end
  
    
end
