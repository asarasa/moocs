class MessagesController < ApplicationController
  before_action :set_course, only: [:reply, :create, :new, :show, :edit, :update, :destroy, :index]
  before_action :set_topic, only: [:reply,:create,:new,:show, :edit, :update, :destroy, :index]
  before_action :set_message, only: [:show, :edit, :update, :destroy]

  # GET /messages
  # GET /messages.json
  def index
    @messages = @topic.messages.asc(:date)
  end

  # GET /messages/1
  # GET /messages/1.json
  def show
  end
  
  # GET /messages/new
  def new
    @message = Message.new
  end

  # GET /messages/1/edit
  def edit
  end
  
  def reply
    @message = Message.new
    render 'new'
  end
  
  # POST /messages
  # POST /messages.json
  def create
    message = Message.new(message_params)
    message.user_id = current_user.id
    @topic.messages << message
    respond_to do |format|
      if @topic.save
        logger.debug "topicsave"
        format.html { redirect_to course_topic_messages_path(@course, @topic), notice: 'Message was successfully created.' }
        format.json { render action: 'show', status: :created, location: @message }
      else
        logger.debug "topicNOsave"

        format.html { render action: 'new' }
        format.json { render json: @message.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /messages/1
  # PATCH/PUT /messages/1.json
  def update
    respond_to do |format|
      if @message.update(message_params)
        format.html { redirect_to course_topic_messages_path(@course,@topic), notice: 'Message was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @message.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /messages/1
  # DELETE /messages/1.json
  def destroy
    @message.destroy
    respond_to do |format|
      format.html { redirect_to  course_topic_messages_path(@course,@topic) }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_message
      @message = @topic.messages.find(params[:id])
    end
  
   def set_topic
      @topic =  Topic.find(params[:topic_id])
    end
  
    # Use callbacks to share common setup or constraints between actions.
    def set_course
      @course = Course.find(params[:course_id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def message_params
      params.require(:message).permit(:title, :content)
    end
end
