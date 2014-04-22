class LessonsController < ApplicationController
  before_action :set_course, only: [:view_resource, :use_resource, :delete_resource, :index, :new, :create, :show, :edit, :update, :destroy]  
  before_action :set_lesson, only: [:view_resource, :use_resource, :delete_resource, :show, :edit, :update, :destroy]
  before_action :set_resource, only: [:use_resource,:view_resource,:delete_resource]
  before_action :authorize_member
  before_action :authorize_teacher, only: [:use_resource, :new, :create, :edit, :update, :destroyed]

  # GET /lessons
  # GET /lessons.json
  def index
    @lessons = @course.lessons
    if @course.is?(current_user, 'teacher')
      render 'teacher_index'
    end
  end

  # GET /lessons/1
  # GET /lessons/1.json
  def show
    @resources = @lesson.resources
    if @course.is?(current_user, 'teacher') && !params[:student]
      @avaliable_resources = current_user.resources - @resources 
      render 'teacher_show'
    end
  end

  # GET /lessons/new
  def new
    @lesson = Lesson.new
  end

  # GET /lessons/1/edit
  def edit
  end

  def use_resource
    if (@lesson.resources.include?(@resource))
      redirect_to course_lesson_path(@course, @lesson), notice: 'The resource is already in the lesson.'
    else
      @lesson.resources << @resource
      if @lesson.save
        redirect_to course_lesson_path(@course, @lesson), notice: 'The resource was successfully added.'
      else
        redirect_to course_lesson_path(@course, @lesson), notice: 'Error.'
      end
    end
  end

  def view_resource
    @resources = @lesson.resources

    render "show"
  end

  def delete_resource
    @lesson.resources.delete(@resource)
    if @lesson.save
        redirect_to course_lesson_path(@course, @lesson), notice: 'The resource was successfully deleted.'
    else
        redirect_to course_lesson_path(@course, @lesson), notice: 'Error.'
    end
  end

  # POST /lessons
  # POST /lessons.json
  def create
    @lesson = Lesson.new(lesson_params)
    @lesson.resources = Array.new
    @course.lessons.push(@lesson)

    respond_to do |format|
      if @course.save
        format.html { redirect_to course_lessons_path(@course), notice: 'Lesson was successfully created.' }
      else
        format.html { render action: 'new' }
      end
    end
  end

  # PATCH/PUT /lessons/1
  # PATCH/PUT /lessons/1.json
  def update
    respond_to do |format|
      if @lesson.update(lesson_params)
        format.html { redirect_to course_lessons_path(@course), notice: 'Lesson was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @lesson.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /lessons/1
  # DELETE /lessons/1.json
  def destroy
    @lesson.destroy
    respond_to do |format|
      format.html { redirect_to course_lessons_path(@course), notice: 'Lesson was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_lesson
      @lesson = @course.lessons.find(params[:id])
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_course
      @course = Course.find(params[:course_id])
    end
  
    def set_resource
      @resource = Resource.find(params[:resource_id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def lesson_params
      params.require(:lesson).permit(:name, :description, :start_date, :end_date)
    end
end
