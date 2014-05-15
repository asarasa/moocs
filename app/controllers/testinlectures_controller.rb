class TestinlecturesController < ApplicationController
  
  before_action :set_course, only: [:multi_solved,:single_solved,:create,:solve,:delete]  
  before_action :set_lecture, only: [:multi_solved,:single_solved,:create,:solve,:delete]
  before_action :set_test, only: [:multi_solved,:single_solved,:create]

  
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
    @scores = Score.where(member: @member , testinlecture: @testinlecture, status: "close").to_a
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
  
  def single_solved
    @testinlecture = Testinlecture.where( test: @test,lecture: @lecture).first
    @member = Member.where(user: current_user, course: @course).first
    @scores = Score.where(member: @member , testinlecture: @testinlecture, status: "close").to_a
    @score = Score.where(member: @member , testinlecture: @testinlecture ).to_a
    @correct= @test.answers.where(valid: true).to_a[0].id      
    @answer = params[:answer]
    if @test.answers.to_a[0].id.to_s == @answer.to_s
      if @score.empty?      
        @empty = true
        @score = Score.new(:testinlecture => @testinlecture ,:member => @member,:attempt => 1,:score => 10,:status => "close")   
        @member.grade = (@member.grade +  @score.score) 
      else
        @score = @score[0]
        @empty = false
        @score.status="close"
        @score.attempt = @score.attempt + 1
        @score.score = 1
        if @score.attempt == 2 
          @score.score = 6 
        elsif @score.attempt == 3 
          @score.score = 3 
        else
          @score.score = 1 
        end     
        @member.grade = (@member.grade + @score.score)
      end
    else
      if @score.empty?
        @empty = true
        @score = Score.new(:testinlecture => @testinlecture ,:member => @member,:attempt => 1,:score => 0,:status => "open")   
      else
        @empty = false
        @score = @score[0]
        if @score.attempt == 3      
          @score.status="close"
            @member.grade = (@member.grade + @score.score) 
        else
           @score.attempt =  @score.attempt + 1
        end   
      end  
    end  
    respond_to do |format|
      if @empty
        @score.save
      else
        @score.update
      end     
      @member.update
        format.js {}
        format.json { render json: "Ok" }
     end
   end
  
  def multi_solved
    @testinlecture = Testinlecture.where( test: @test,lecture: @lecture).first
    @scores = Score.where(member: @member , testinlecture: @testinlecture, status: "close").to_a
    @member = Member.where(user: current_user, course: @course).first
    if params[:answers].nil?
       @answers=Array.new
     else 
       @answers=params[:answers]
     end  
    @correct = Array.new
    @test.answers.where(valid: true).to_a.each do |cor|
      @correct << cor.id.to_s
    end  
    max = @test.answers.to_a.count
    result = 0
    fails = 0
    @test.answers.each do |answer|
      if @answers.to_a.include?(answer.id.to_s)
        if answer.valid==true
          result = result + 1
        else
          fails = fails + 1
        end  
      else
        if answer.valid==false
           result = result + 1
        else
          fails = fails + 1
        end  
      end     
    end 
    value = ((result * 10 / max).to_f.round(2) ) - (((fails * 10) / (max * 4)).to_f.round(2) )
    @member.grade = (@member.grade + value) 
    @score = Score.new(:testinlecture => @testinlecture ,:member => @member,:attempt => 1,:score => value,:status => "close")  
     respond_to do |format|    
       if @score.save and @member.update
        format.js {}
        format.json { render json: "Ok" }
       else
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
