class QuizzesController < ApplicationController
  before_action :set_resource, only: [:new_answers,:index, :new, :create, :show, :edit, :update, :destroy] 
  before_action :set_quiz, only: [:show, :edit, :update, :destroy]

  # GET /quizzes
  # GET /quizzes.json
  def index
    @quizzes = @resource.quizzes
  end

  # GET /quizzes/1
  # GET /quizzes/1.json
  def show
    
  end
  
  def add_answers
     @resource = Resource.find(params[:resource_id])
     @quiz = @resource.quizzes.find(params[:quiz_id])
  end

  def solve
     params.require(:quiz).permit(:answer)
     @resource = Resource.find(params[:resource_id])
     @quiz = @resource.quizzes.find(params[:quiz_id])
     @quizzes = @resource.quizzes
     @quiz.users = Array.new
     index=0
     hash = params[:quiz][:answer]
     list = Array.new  
     hash.each do |a|    
        if (a[1][:results] == "1")
         list.push(index)
        end  
        index = index + 1
     end
    if (list == @quiz.results) 
      @quiz.users.push(current_user.id)
      respond_to do |format|
        if @quiz.update()
          format.html { redirect_to resource_quizzes_path(@resource), notice: 'Quiz was successfully solved' }
        else
          format.html { render action: 'show' }
        end
      end    
    else 
       render 'show'
    end    
  end

  
  def new_answers
    @quiz = @resource.quizzes.find(params[:quiz_id])
    @quiz.answers = Array.new
    @quiz.results = Array.new 
    index=0
    hash = params[:quiz][:answer]
    hash.each do |a|
      @quiz.answers.push(a[1][:answers])
      if (a[1][:results] == "1")
        @quiz.results.push(index)
      end  
      index = index + 1
    end
    respond_to do |format|
      if @quiz.update()
        format.html { redirect_to resource_quizzes_path(@resource), notice: 'Quiz was successfully updated, update the answers.' }
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
    @quiz.users = Array.new
    @resource.quizzes.push(@quiz)
    
    respond_to do |format|
      if @resource.save
        format.html { redirect_to resource_quiz_add_answers_path(@resource,@quiz), notice: 'Quiz was successfully, enter the answers.' }
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
      format.html { redirect_to resource_quizzes_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_quiz
      @quiz = @resource.quizzes.find(params[:id])
     
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def quiz_params
      params.require(:quiz).permit(:question, :multianswer,:numanswers,:answer)
    end
  
    
  
  def set_resource
    @resource = Resource.find(params[:resource_id])
  end
end
