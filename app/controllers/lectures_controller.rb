class LecturesController < ApplicationController
  before_action :set_course, only: [:view_resource, :use_resource, :delete_resource, :index, :new, :create, :show, :edit, :update, :destroy]  
  before_action :set_lecture, only: [:view_resource, :use_resource, :delete_resource, :show, :edit, :update, :destroy]
  before_action :authorize_member
  before_action :authorize_teacher, only: [:use_resource, :new, :create, :edit, :update, :destroyed]

  # GET /lectures
  # GET /lectures.json
  def index
    @lectures = @course.lectures.order_by(:start_date.asc)
  end

  # GET /lectures/1
  # GET /lectures/1.json
  def show
    if @course.is?(current_user, 'teacher') && !params[:student]
      @lessons = @lecture.lessons.order_by(:order.asc)
      @lesson = @lessons.first
      render 'teacher_show'
    else
      @lessons = @lecture.lessons.where(active: "true").order_by(:order.asc)
      @lesson = @lessons.first      
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
      @lecture = @course.lectures.find(params[:id])
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
