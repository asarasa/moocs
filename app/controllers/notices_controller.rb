class NoticesController < ApplicationController
  before_action :set_course, only: [:new, :create, :edit, :update, :destroy]
  before_action :set_notice, only: [:edit, :update, :destroy]
  before_action :authorize, only: [:edit, :new, :create, :update, :destroy]
  before_action :authorize_teacher, only: [:edit, :update, :destroy]

  # GET /notices/new
  def new
    @notice = Notice.new
  end

  # GET /notices/1/edit
  def edit
  end

  # POST /notices
  # POST /notices.json
  def create
    @notice = Notice.new(notice_params)
    @course.notices << @notice

    respond_to do |format|
      if @course.save
        format.html { redirect_to @course, notice: 'Notice was successfully created.' }
        format.json { render action: 'show', status: :created, location: @course }
      else
        format.html { render action: 'new' }
        format.json { render json: @course.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /notices/1
  # PATCH/PUT /notices/1.json
  def update
    respond_to do |format|
      if @notice.update(notice_params)
        format.html { redirect_to @course, notice: 'Notice was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @notice.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /notices/1
  # DELETE /notices/1.json
  def destroy
    @notice.destroy
    respond_to do |format|
      format.html { redirect_to @course }
      format.json { head :no_content }
    end
  end

  private

    def set_notice
      @notice = @course.notices.find(params[:id])
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_course
      @course = Course.find(params[:course_id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def notice_params
      params.require(:notice).permit(:title, :content)
    end
end