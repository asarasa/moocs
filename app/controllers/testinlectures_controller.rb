class TestinlecturesController < ApplicationController
  
  before_action :set_course, only: [:solved,:create,:solve,:delete]  
  before_action :set_lecture, only: [:solved,:create,:solve,:delete]
  before_action :set_test, only: [:solved,:create]

  
  def create
      testinlecture=Testinlecture.new    
      testinlecture.test = Test.find(@test)
      testinlecture.active = false
      @lecture.testinlectures << testinlecture   
      respond_to do |format|
        if @lecture.update
          format.html { redirect_to course_lecture_path(@course,@lecture), notice: 'Lecture was successfully updated.' }
        else
          format.html { render course_lecture_path(@course,@lecture), notice: 'Error.'}
        end
    end
  end

    def change_visibility
      testinlecture = Testinlecture.find(params[:id]);    
      respond_to do |format|
        if testinlecture.change_visibility
          format.json { render json: "OK" }
        else
          format.json { render json: "Error" }
        end
      end
    end 
  
   def solve
    @member = Member.where(user: current_user, course: @course).first
    @testinlecture = Testinlecture.find(params[:id])
    @test = Test.find(@testinlecture.test)
    @scoresClose = Score.where(member: @member , testinlecture: @testinlecture, status: "close").to_a
    @scoresOpen = Score.where(member: @member , testinlecture: @testinlecture, status: "open").to_a
    respond_to do |format|
      if !@test.nil?
        format.html { }
        format.js {}
        format.json { render json: "Ok" }
      else
        format.html {  }
        format.js {}
        format.json { render json: "Error" }
      end
    end
   end 
  
  def solved
    @testinlecture = Testinlecture.where( test: @test,lecture: @lecture).first
    @member = Member.where(user: current_user, course: @course).first
    @scoresClose = Score.where(member: @member , testinlecture: @testinlecture, status: "close").to_a
    @score = Score.where(member: @member , testinlecture: @testinlecture ).to_a     
    @answer = params[:answer]
    if params[:answers].nil?
      @answers=Array.new
    else 
      @answers=params[:answers]
    end  
    respond_to do |format|
      if  results=@testinlecture.update_score(@test,@testinlecture, @answer,@score,@member,@answers)
        @scoresOpen = Score.where(member: @member , testinlecture: @testinlecture, status: "open").to_a
        @score=results[:score]
        @correct=results[:correct]
        format.js {}
        format.json { render json: "Ok" }
      else
        logger.debug("error de @score") 
        format.js {}
        format.json { render json: "Error" }
     end
   end
  end  
  
  
  def delete
    testinlecture = Testinlecture.find(params[:id])
    testinlecture.destroy
    respond_to do |format|
      format.html { redirect_to course_lecture_path(@course, @lecture)}
      format.json { head :no_content }
    end
  end
  
    # Use callbacks to share common setup or constraints between actions.
    def set_course
      @course = Course.find(params[:course_id])
    end
  
  def set_lecture
    if params[:lecture_id].nil?
        @lecture = @course.lectures.find(params[:id])
      else
        @lecture = @course.lectures.find(params[:lecture_id])
      end
    end

     
     def set_test
      if !params[:id].nil?
        @test = Test.find(params[:id])
      elsif !params[:quiz_id].nil?
        @test = Test.find(params[:quiz_id])
      else
        @test = Test.find(params[:test_id])
      end
    end
end
