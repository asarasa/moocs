class LecturesController < ApplicationController
  before_action :set_course, only: [:solve,:select_tests,:selected_tests,:view_resource, :use_resource, :delete_resource, :index, :new, :create, :show, :edit, :update, :destroy]  
  before_action :set_lecture, only: [:solve,:select_tests,:selected_tests,:view_resource, :use_resource, :delete_resource, :show, :edit, :update, :destroy]
  before_action :authorize_member
  before_action :authorize_teacher, only: [:use_resource, :new, :create, :edit, :update, :destroyed]

  # GET /lectures
  # GET /lectures.json
  def index
    @lectures = @course.lectures.order_by(:start_date.asc)
  end

  def select_tests
    @tests = current_user.tests.any_of({:_type => "Quiz"})
  end
  
  def selected_tests  
     @lecture.testinlectures.clear
    if !params[:tests].nil?
        @tests = params[:tests] 
        @tests.each do |test|
        @test = Test.find(test)
        testinlecture=Testinlecture.new    
        testinlecture.test = Test.find(@test)
        testinlecture.active = false
        @lecture.testinlectures << testinlecture
      end  
    end  
    respond_to do |format|
      if @lecture.update
          format.html { redirect_to course_lecture_path(@course,@lecture), notice: 'Lecture was successfully updated.' }
      else
          format.html { render action: 'show' }
      end
    end
   
  end
 
  # GET /lectures/1
  # GET /lectures/1.json
  def show
    @user_tests = current_user.tests.any_of({:_type => "Quiz"})
    if @course.is?(current_user, 'teacher') && !params[:student]
      @lessons = @lecture.lessons.order_by(:order.asc)
      @lesson = @lessons.first
      @testinlectures =  @lecture.testinlectures
      render 'teacher_show'
    else
      @lessons = @lecture.lessons.where(active: "true").order_by(:order.asc)
      @lesson = @lessons.first
      @testinlectures =  @lecture.testinlectures.where(active: "true")
    end
  end

  # GET /lectures/new
  def new
    @lecture = Lecture.new
  end

  # GET /lectures/1/edit
  def edit
  end

  # POST /lectures
  # POST /lectures.json
  def create
    @lecture = Lecture.new(lecture_params)
    @course.lectures.push(@lecture)

    respond_to do |format|
      if @course.save
        format.html { redirect_to course_lectures_path(@course), notice: 'Lecture was successfully created.' }
      else
        format.html { render action: 'new' }
      end
    end
  end

  # PATCH/PUT /lectures/1
  # PATCH/PUT /lectures/1.json
  def update
    respond_to do |format|
      if @lecture.update(lecture_params)
        format.html { redirect_to course_lectures_path(@course), notice: 'Lecture was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @lecture.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /lectures/1
  # DELETE /lectures/1.json
  def destroy
    @lecture.destroy
    respond_to do |format|
      format.html { redirect_to course_lectures_path(@course), notice: 'Lecture was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_lecture
      if !params[:id].nil?
        @lecture = @course.lectures.find(params[:id])
      else
        @lecture = @course.lectures.find(params[:lecture_id])
      end
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_course
      @course = Course.find(params[:course_id])
    end
  
    # Never trust parameters from the scary internet, only allow the white list through.
    def lecture_params
      params.require(:lecture).permit(:name, :description, :start_date, :end_date)
    end

end
