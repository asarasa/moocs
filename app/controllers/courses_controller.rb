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
    @teachers = User.find(@course.teachers)
    if is_teacher?
      render 'teacher_show'
    end
  end

  def join_course
    if @course.users.include? current_user
      redirect_to @course, notice: 'You are already enrolled in this course.'
    else
      @course.users.push(current_user)
      redirect_to @course, notice: 'You have successfully registered.'
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
    @course.users.push(current_user)
    @course.teachers = [current_user.id]

    respond_to do |format|
      if @course.save
        current_user.courses.push(@course)
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
      params.require(:course).permit(:name, :desc, :start_date, :end_date, :estimated_effort, :prerequisites)
    end
end
