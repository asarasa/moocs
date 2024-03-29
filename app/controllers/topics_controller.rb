class TopicsController < ApplicationController
  before_action :set_course, only: [:create,:new,:show, :edit, :update, :destroy, :index]
  before_action :set_topic, only: [:show, :edit, :update, :destroy]
  
  # GET /topics
  # GET /topics.json
  def index
    @topics = @course.topics.asc(:date)
  end

  # GET /topics/1
  # GET /topics/1.json
  def show 
  end

  # GET /topics/new
  def new
    @topic = Topic.new
  end

  # GET /topics/1/edit
  def edit
  end
  
  # POST /topics
  # POST /topics.json
  def create
    @topic = Topic.new(topic_params)
    @topic.user = current_user
    @course.topics << @topic
    respond_to do |format|
      if @topic.save
        format.html { redirect_to course_topics_path(@course), notice: 'Topic was successfully created.' }
        format.json { head :no_content }
      else
        format.html { render action: 'new' }
        format.json { render json: topic.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /topics/1
  # PATCH/PUT /topics/1.json
  def update
    
    respond_to do |format|
      if @topic.update(topic_params)
        format.html { redirect_to course_topics_path(@course), notice: 'Topic was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @topic.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /topics/1
  # DELETE /topics/1.json
  def destroy
    @course.topics.delete(@topic)
    @topic.destroy
    respond_to do |format|
      format.html { redirect_to course_topics_path(@course)}
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_topic
      @topic =  @course.topics.find(params[:id])
    end
  
    # Use callbacks to share common setup or constraints between actions.
    def set_course
      @course = Course.find(params[:course_id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def topic_params
      params.require(:topic).permit(:title, :content, :state)
    end
end
