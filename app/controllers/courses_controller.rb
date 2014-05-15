class CoursesController < ApplicationController
  before_action :set_course, only: [:change_state, :show, :join_course, :edit, :update, :destroy]
  before_action :authorize, only: [:join_course, :edit, :new, :create, :update, :destroy]
  before_action :authorize_teacher, only: [:change_state, :edit, :update, :destroy]


  # GET /courses
  # GET /courses.json
  def index
    @courses = Course.all
  end

  # GET /courses/1
  # GET /courses/1.json
  def show
  end
  
def tracking
    @course = Course.find(params[:course_id])
    @lectures = @course.lectures   
    @categories = Array.new
    @score = Array.new
    @average=Array.new
    @max=Array.new
    @min=Array.new
    @lt5 =Array.new
    @b58=Array.new
    @gt8=Array.new
    cinco= (@course.num_tests * 5)
    ocho= (@course.num_tests * 8)
      @lectures.each do |lecture|
        lecture.testinlectures.each do |testinlecture|
          @categories << Test.find(testinlecture.test).name
          @average << Score.where(testinlecture: testinlecture).avg(:score)
          @max << Score.where(testinlecture: testinlecture).max(:score)
          @min << Score.where(testinlecture: testinlecture).min(:score)       
          @lt5 << Member.where(:grade.lt => cinco).count
          @b58 << Member.where(:grade.lt => ocho,:grade.gte => cinco).count
          @gt8 << Member.where(:grade.gte => ocho).count
        end  
      end  
      if @course.is?(current_user,"teacher") 
        @chart = LazyHighCharts::HighChart.new('graph') do |f|
          f.title( :text=>"Course Statistics")
          f.options[:xAxis][:categories] = @categories
          f.options[:yAxis][:max] = 10
          f.series(:type=> 'column',:color => :red,:name=> 'Worst',:data=> @min, :dataLabels => {
                      :enabled=> true, 
                      color: '#FFFFFF',
            align: 'center',
                      x: 4,
                      y: 10,
                      style: {
                          fontSize: '13px',
                          fontFamily: 'Verdana, sans-serif',
                          textShadow: '0 0 3px black'
                      }})
          f.series(:type=> 'column',:color => :green, :name=> 'Best',:data=> @max, :dataLabels => {
                      :enabled => true, 
                      color: '#FFFFFF',
                      align: 'center',
                      x: 4,
                      y: 10,
                      style: {
                          fontSize: '13px',
                          fontFamily: 'Verdana, sans-serif',
                          textShadow: '0 0 3px black'
                      }})
          f.series(:type=> 'spline',:color => :blue ,:name=> 'Average', :data=>  @average)
          f.series(:type=> 'pie',:name=> 'alumn average rattings', 
          :data=> [
            {:name=> '<5', :y=> @lt5 , :color=> 'red'}, 
            {:name=> '5-8', :y=> @b58,:color=> 'blue'},
            {:name=> '8-10', :y=> @gt8,:color=> 'green'}
          ],
            :center=> [40, 30], :size=> 100, :showInLegend => false,:allowPointSelect => true,
                      :dataLabels=> {:enabled=> false })

        end
      else     
         @member = Member.where(user: current_user, course: @course).first
         @lectures.each do |lecture|
          lecture.testinlectures.each do |testinlecture|
            score = Score.where(testinlecture: testinlecture , member: @member)
            if !score.empty?
              @score << score.first.score
            end  
          end  
        end  
         @chart = LazyHighCharts::HighChart.new('graph') do |f|
           f.title(:text => "Your course rating")
           f.options[:xAxis][:categories] = @categories
           f.options[:yAxis][:max] = 10
           f.series(:type=> 'column',:data=> @score, :dataLabels => {
                     :enabled=> true,
                     color:'#FFFFFF',
                     align: 'center',
                      x: 4,
                      y: 20,
                      style: {
                          fontSize: '13px',
                          fontFamily: 'Verdana, sans-serif',
                          textShadow: '0 0 3px black'
                        }})       
           f.series(:type=> 'spline',:color => :blue , :name=> 'Average', :data=> @average) 
           f.series(:type=> 'spline',:color => :green , :name=> 'Best', :data=> @max) 
           f.series(:type=> 'spline',:color => :red , :name=> 'Worst', :data=> @min) 
         end 
         @grade = @member.grade / @course.num_tests
    end
 end

  def change_state
    respond_to do |format|
      if @course.change_state
        format.html { redirect_to @course, notice: 'State was successfully changed.' }
      else
        format.html { redirect_to @course, notice: 'State was not successfully changed.' }
      end
    end
  end   


  def join_course
    if @course.add_member(current_user, "student")
      redirect_to course_lectures_path(@course), notice: 'You have successfully registered.'
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

    respond_to do |format|
      if @course.add_member(current_user, "teacher") && @course.save
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
      if !params[:id].nil?
        @course = Course.find(params[:id])
      else
        @course = Course.find(params[:course_id])
      end      
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def course_params
      params.require(:course).permit(:forumpermision,:name, :desc, :abstract, :start_date, :end_date, :estimated_effort, :category, :prerequisites, :banner)
    end
end
