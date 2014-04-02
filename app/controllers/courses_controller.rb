class CoursesController < ApplicationController
  before_action :set_course, only: [:show, :join_course, :edit, :update, :destroy]
  before_action :authorize, only: [:join_course, :edit, :new, :create, :update, :destroy]
  before_action :authorize_teacher, only: [:edit, :update, :destroy]


  # GET /courses
  # GET /courses.json
  def index
    @courses = Course.all
  end

  # GET /courses/1
  # GET /courses/1.json
  def show
    if @course.is_member?(current_user, "teacher")
      render 'teacher_show'
    end
  end
  
   def tracking
    @course = Course.find(params[:course_id])
    @lessons = @course.lessons   
    if is_teacher?
      @chart = LazyHighCharts::HighChart.new('graph') do |f|
      f.title({ :text=>"Course Statistics"})
      f.options[:xAxis][:categories] =  ["leccion1", "leccion2"]
      f.labels(:items=>[:html=>"Course rattings", :style=>{:left=>"20px", :top=>"100px", :color=>"black"} ])      
      f.series(:type=> 'column',:name=> 'Worst',:data=> [3,4])
      f.series(:type=> 'column', :name=> 'Best',:data=> [7,9])
      f.series(:type=> 'spline',:name=> 'Average', :data=> [4.5,5.7])
      f.series(:type=> 'pie',:name=> 'alumn average rattings', 
        :data=> [
          {:name=> '<5', :y=> 98, :color=> 'red'}, 
          {:name=> '5-8', :y=> 15,:color=> 'blue'},
          {:name=> '8-10', :y=> 3,:color=> 'green'}
        ],
        :center=> [40, 30], :size=> 100, :showInLegend=> false)
      end
      render 'teacher_tracking'
    else  
     @chart = LazyHighCharts::HighChart.new('graph') do |f|
      f.title(:text => "Your course rating")
      f.options[:xAxis][:categories] =  ["leccion1", "leccion2"]      
      f.series(:type=> 'column',:name=> 'Your rating',:data=> [3,4])
      f.series(:type=> 'column', :name=> 'Lesson Average',:data=> [7,9])
      f.series(:type=> 'spline',:name=> 'Average', :data=> [4.5,5.7])
     end  
    end
  end


  def join_course
    if @course.add_member(current_user, "student")
      redirect_to course_lessons_path(@course), notice: 'You have successfully registered.'
    else
      redirect_to @course, notice: 'You are already enrolled in this course.'
    end
  end

  # GET /courses/new
  def new
    @course = Course.new
  end

  # GET /courses/1/edit
  def edit
  end

  # POST /courses
  # POST /courses.json
  def create
    @course = Course.new(course_params)
    @course.tags = params[:course][:tags].split(";")

    respond_to do |format|
      if @course.add_member(user, "teacher") && @course.save
        format.html { redirect_to @course, notice: 'Course was successfully created.' }
        format.json { render action: 'show', status: :created, location: @course }
      else
        format.html { render action: 'new' }
        format.json { render json: @course.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /courses/1
  # PATCH/PUT /courses/1.json
  def update
    respond_to do |format|
      if @course.update(course_params)
        format.html { redirect_to @course, notice: 'Course was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @course.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /courses/1
  # DELETE /courses/1.json
  def destroy
    @course.destroy
    respond_to do |format|
      format.html { redirect_to courses_url }
      format.json { head :no_content }
    end
  end

  
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_course
      @course = Course.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def course_params
      params.require(:course).permit(:forumpermision,:name, :desc, :abstract, :start_date, :end_date, :estimated_effort, :prerequisites)
    end
end
