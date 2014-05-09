class LessonsController < ApplicationController
  before_action :set_course, only: [:select_lesson, :change_state, :change_order, :view_resource, :use_resource, :delete_resource, :index, :new, :create, :show, :edit, :update, :destroy]  
  before_action :set_lecture, only: [:select_lesson, :change_state, :change_order, :new, :create, :view_resource, :use_resource, :delete_resource, :show, :edit, :update, :destroy]
  before_action :set_lesson, only: [:select_lesson, :change_state, :view_resource, :use_resource, :delete_resource, :index, :show, :edit, :update, :destroy]  
  before_action :authorize_member
  before_action :authorize_teacher, only: [:use_resource, :new, :create, :edit, :update, :destroyed]

  # GET /lectures/new
  def new
    @lesson = Lesson.new
    @resources = current_user.resources
  end

  # GET /lectures/1/edit
  def edit
    @resources = current_user.resources
  end

  def select_lesson
    @lesson = Lesson.find(params[:lesson_id])

    respond_to do |format|
      if !@lesson.nil?
        format.html { render @lesson }
        format.js {}
        format.json { render json: @lesson, status: :lesson, location: @lesson }
      else
        format.html { render @lesson }
        format.js {}
        format.json { render json: "Error" }
      end
    end
  end

  def change_order
    lesson = @lecture.lessons.find(params[:id1]);

    respond_to do |format|
      if lesson.change_order(params[:id2])
        format.json { render json: "OK" }
      else
        format.json { render json: "Error" }
      end
    end
  end  

  def change_state
    lesson = Lesson.find(params[:id]);
    
    respond_to do |format|
      if lesson.change_state
        format.json { render json: "OK" }
      else
        format.json { render json: "Error" }
      end
    end
  end    

  # POST /lectures
  # POST /lectures.json
  def create
    @lesson = Lesson.new(lesson_params)
    @lesson.resources = Array.new
    resources = params[:resource_ids]

    if !resources.nil?
      resources.each do |resource|
        @lesson.resources << Resource.find(resource)
      end
    end

    if (@lecture.lessons.length > 0)
      @lesson.order = @lecture.lessons.order_by(:order.asc).last.order + 1
    else
      @lesson.order = 1
    end
    @lesson.active = false;

    respond_to do |format|
      if @lesson.save
        @lecture.lessons << @lesson
        format.html { redirect_to course_lecture_path(@course, @lecture), notice: 'Lesson was successfully created.' }
      else
        format.html { render action: 'new' }
      end
    end
  end

  # PATCH/PUT /lectures/1
  # PATCH/PUT /lectures/1.json
  def update
    @lesson.resources.clear
    resources = params[:resource_ids]

    resources.each do |resource|
      @lesson.resources << Resource.find(resource)
    end

    respond_to do |format|
      if @lesson.update(lesson_params)
        format.html { redirect_to course_lecture_path(@course, @lecture), notice: 'Lecture was successfully updated.' }
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
    @lesson.destroy
    respond_to do |format|
      format.html { redirect_to course_lectures_path(@course), notice: 'Lesson was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_course
      @course = Course.find(params[:course_id])
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_lecture
      @lecture = @course.lectures.find(params[:lecture_id])
    end
 
    def set_lesson
      if !params[:id].nil?
        @lesson = @lecture.lessons.find(params[:id])
      else
        @lesson = @lecture.lessons.find(params[:lesson_id])
      end
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def lesson_params
      params.require(:lesson).permit(:name, :description)
    end
end
